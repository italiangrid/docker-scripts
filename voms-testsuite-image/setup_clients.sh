#!/bin/bash
set -ex

trap "exit 1" TERM
export TOP_PID=$$

terminate() {
    echo $1 && kill -s TERM $TOP_PID
}

## The testsuite repo
TESTSUITE=${TESTSUITE:-git://github.com/italiangrid/voms-testsuite.git}

# VO 1 configuration
VO1_HOST=${VO1_HOST:-voms-server}
VO1_PORT=${VO1_PORT:-15000}
VO1=${VO1:-vomsci}
VO1_ISSUER=${VO1_ISSUER:-/C=IT/O=INFN/OU=Host/L=CNAF/CN=voms-server}

# VO 2 configuration
VO2_HOST=${VO2_HOST:-vgrid02.cnaf.infn.it}
VO2_PORT=${VO2_PORT:-15001}
VO2=${VO2:-test.vo.2}
VO2_ISSUER=${VO2_ISSUER:-/C=IT/O=INFN/OU=Host/L=CNAF/CN=vgrid02.cnaf.infn.it}

SYNC_SLEEP_TIME=${SYNC_SLEEP_TIME:-5}
SYNC_FILE=${SYNC_FILE:-/sync/start-ts}
SYNC_MAX_RETRIES=200

sync(){
  attempts=1

  while [ ! -f ${SYNC_FILE} ]; do
    sleep ${SYNC_SLEEP_TIME}
    let attempts+=1
    [ ${attempts} -ge ${SYNC_MAX_RETRIES} ] && break
  done

  [ ${attempts} -ge ${SYNC_MAX_RETRIES} ] && terminate "Sync timeout!"
}

## Creates a VOMSES file
make_vomses() {
  local vo_name=$1
  local vo_host=$2
  local vo_port=$3
  local vo_issuer=$4

  rm -rf /etc/vomses/${vo_name}
  cat << EOF > /etc/vomses/${vo_name}
  "${vo_name}" "${vo_host}" "${vo_port}" "${vo_issuer}" "${vo_name}"
EOF
  cat /etc/vomses/${vo_name}
}

## Creates an LSC file
make_lsc(){
  local vo_name=$1
  local vo_host=$2
  local vo_port=$3

  local make_lsc_cmd="openssl s_client -connect ${vo_host}:${vo_port} | \
    openssl x509 -noout -subject -issuer 2>/dev/null | \
    sed -e 's/subject= //g' -e 's/issuer= //g'"

  mkdir -p /etc/grid-security/vomsdir/${vo_name}
  eval ${make_lsc_cmd} > /etc/grid-security/vomsdir/${vo_name}/${vo_host}.lsc
  cat /etc/grid-security/vomsdir/${vo_name}/${vo_host}.lsc
}

# check and install the extra repo for VOMS clients if provided by user
if [ -z $VOMSREPO ]; then
  echo "No clients repo provided. Installing default version (EMI3)"
else
  wget "$VOMSREPO" -O /etc/yum.repos.d/vomsclients.repo
  if [ $? != 0 ]; then
    echo "A problem occurred when downloading the provided repo. Installing default version (EMI3)"
  fi
fi

yum install -y voms-clients3
yum install -y myproxy

## Setup vomses file for the two test VOs
sync
make_vomses ${VO1} ${VO1_HOST} ${VO1_PORT} ${VO1_ISSUER}
make_vomses ${VO2} ${VO2_HOST} ${VO2_PORT} ${VO2_ISSUER}

## Setup LSC file for the two test VOs
make_lsc ${VO1} ${VO1_HOST} ${VO1_PORT}
make_lsc ${VO2} ${VO2_HOST} ${VO2_PORT}

cat << EOF > /home/voms/run-testsuite.sh
#!/bin/bash 
set -ex
git clone $TESTSUITE
pushd ./voms-testsuite
pybot \
  --variable vo1:$VO1 \
  --variable vo1_host:$VO1_HOST \
  --variable vo1_issuer:$VO1_ISSUER \
  --variable vo2:$VO2 \
  --variable vo2_host:$VO2_HOST \
  --variable vo2_issuer:$VO2_ISSUER \
  --pythonpath lib \
  -d reports \
  tests/clients
EOF

chmod +x /home/voms/run-testsuite.sh
chown voms:voms /home/voms/run-testsuite.sh

# install and execute the VOMS testsuite as user voms
su - voms -c /home/voms/run-testsuite.sh
