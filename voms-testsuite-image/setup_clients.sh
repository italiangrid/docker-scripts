#!/bin/bash
set -x

VO_HOST=${VO_HOST:-vgrid02.cnaf.infn.it}
VO_PORT=${VO_PORT:-15000}
VO=${VO:-test.vo}
VO_ISSUER=${VO_ISSUER:-/C=IT/O=INFN/OU=Host/L=CNAF/CN=vgrid02.cnaf.infn.it}
VO_ISSUER_CA=${VO_ISSUER_CA:-/C=IT/O=INFN/CN=INFN CA}
TESTSUITE=${TESTSUITE:-git://github.com/italiangrid/voms-testsuite.git}

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

## Create VOMSES file for VO
rm -rf /etc/vomses/${VO}*
cat << EOF > /etc/vomses/${VO}-${VO_HOST}
"${VO}" "${VO_HOST}" "${VO_PORT}" "${VO_ISSUER}" "${VO}"
EOF

## Print out VOMSES file content
cat /etc/vomses/${VO}-${VO_HOST}

make_lsc_cmd="openssl s_client -connect ${VO_HOST}:${VO_PORT} | openssl x509 -noout -subject -issuer | sed -e 's/subject= //g' -e 's/issuer= //g'"

## Create LSC file for VO
mkdir -p /etc/grid-security/vomsdir/${VO}
eval ${make_lsc_cmd} > /etc/grid-security/vomsdir/${VO}/${VO_HOST}.lsc

## Print out lSC file content
cat /etc/grid-security/vomsdir/${VO}/${VO_HOST}.lsc

cat << EOF > /home/voms/run-testsuite.sh
#!/bin/bash 
set -ex
git clone $TESTSUITE
pushd ./voms-testsuite
pybot --variable vo1_host:$VO_HOST \
  --variable vo1:$VO \
  --variable vo1_issuer:$VO_ISSUER \
  --pythonpath lib -d reports \
  tests/clients
EOF

chmod +x /home/voms/run-testsuite.sh
chown voms:voms /home/voms/run-testsuite.sh

# install and execute the VOMS testsuite as user "voms"
su - voms -c /home/voms/run-testsuite.sh
