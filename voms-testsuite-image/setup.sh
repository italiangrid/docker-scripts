#!/bin/bash
set -x

trap "exit 1" TERM
export TOP_PID=$$

terminate() {
    echo $1 && kill -s TERM $TOP_PID
}

env

## The testsuite repo
TESTSUITE=${TESTSUITE:-git://github.com/italiangrid/voms-testsuite.git}

# VO 1 configuration
VO1=${VO1:-vo.0}
VO1_HOST=${VO1_HOST:-voms-server}
VO1_PORT=${VO1_PORT:-15000}
VO1_ISSUER=${VO1_ISSUER:-/C=IT/O=IGI/CN=voms-server}

# VO 2 configuration
VO2=${VO2:-vo.1}
VO2_HOST=${VO2_HOST:-voms-server}
VO2_PORT=${VO2_PORT:-15001}
VO2_ISSUER=${VO2_ISSUER:-/C=IT/O=IGI/CN=voms-server}

MYPROXY_SERVER=${MYPROXY_SERVER:-omii001.cnaf.infn.it}
MYPROXY_PASSWORD=${MYPROXY_PASSWORD:-123456}

SYNC_SLEEP_TIME=${SYNC_SLEEP_TIME:-5}
SYNC_FILE=${SYNC_FILE:-/sync/start-ts}
SYNC_MAX_RETRIES=${SYNC_MAX_RETRIES:-200}

INCLUDE_TESTS=${INCLUDE_TESTS:-""}
EXCLUDE_TESTS=${EXCLUDE_TESTS:-""}

sync(){
  if [ -z "${NO_SYNC}" ]; then

    attempts=1
    while [ ! -f ${SYNC_FILE} ]; do
      sleep ${SYNC_SLEEP_TIME}
      let attempts+=1
      [ ${attempts} -ge ${SYNC_MAX_RETRIES} ] && break
    done

    [ ${attempts} -ge ${SYNC_MAX_RETRIES} ] && terminate "Sync timeout!"

  fi
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

  local make_lsc_cmd="openssl s_client -connect ${vo_host}:${vo_port} 2>/dev/null | \
    openssl x509 -noout -subject -issuer 2>/dev/null | \
    sed -e 's/subject= //g' -e 's/issuer= //g'"

  mkdir -p /etc/grid-security/vomsdir/${vo_name}
  eval ${make_lsc_cmd} > /etc/grid-security/vomsdir/${vo_name}/${vo_host}.lsc
  cat /etc/grid-security/vomsdir/${vo_name}/${vo_host}.lsc
}

# check and install the extra repo for VOMS clients if provided by user
if [ -z ${VOMS_REPO} ]; then
  echo "No clients repo provided. Installing default version (EMI3)"
else
  wget "${VOMS_REPO}" -O /etc/yum.repos.d/vomsclients.repo
  if [ $? != 0 ]; then
    echo "A problem occurred when downloading the provided repo. Installing default version (EMI3)"
  fi
fi

if [ -n "${UPDATE_VOMS_CLIENTS}" ]; then
  yum -y update voms-clients3
fi

if [ -n "${REINSTALL_VOMS_CLIENTS}" ]; then
  yum -y reinstall voms-clients3
fi

## Setup vomses file for the two test VOs
sync
make_vomses ${VO1} ${VO1_HOST} ${VO1_PORT} ${VO1_ISSUER}
make_vomses ${VO2} ${VO2_HOST} ${VO2_PORT} ${VO2_ISSUER}

## Setup LSC file for the two test VOs
make_lsc ${VO1} ${VO1_HOST} ${VO1_PORT}
make_lsc ${VO2} ${VO2_HOST} ${VO2_PORT}

## Print out voms clients version
voms-proxy-init --version

## Run fetch-crl
fetch-crl

ROBOT_OPTIONS="--variable vo1:$VO1 \
  --variable vo1_host:$VO1_HOST \
  --variable vo1_issuer:$VO1_ISSUER \
  --variable vo2:$VO2 \
  --variable vo2_host:$VO2_HOST \
  --variable vo2_issuer:$VO2_ISSUER \
  --variable myproxy_server:$MYPROXY_SERVER \
  --variable myProxyPassPhrase:$MYPROXY_PASSWORD \
  --pythonpath .:lib \
  -d reports "

if [ -n "${INCLUDE_TESTS}" ]; then
  ROBOT_OPTIONS="${ROBOT_OPTIONS} --include ${INCLUDE_TESTS}"
fi

if [ -n "${EXCLUDE_TESTS}" ]; then
  ROBOT_OPTIONS="${ROBOT_OPTIONS} --exclude ${EXCLUDE_TESTS}"
fi

cat << EOF > /home/voms/run-testsuite.sh
#!/bin/bash
set -ex
git clone ${TESTSUITE} voms-testsuite
pushd ./voms-testsuite
ROBOT_OPTIONS="${ROBOT_OPTIONS}" pybot tests/clients
EOF

chmod +x /home/voms/run-testsuite.sh
chown voms:voms /home/voms/run-testsuite.sh

# install and execute the VOMS testsuite as user voms
su - voms -c /home/voms/run-testsuite.sh
