#!/bin/bash
set -x

VO_HOST="${VO_HOST:-vgrid02.cnaf.infn.it}"
VO="${VO:-test.vo}"
VO_ISSUER="${VO_ISSUER:-/C=IT/O=INFN/OU=Host/L=CNAF/CN=vgrid02.cnaf.infn.it}"
TESTSUITE="${TESTSUITE:-git://github.com/italiangrid/voms-testsuite.git}"

# check and install the extra repo for VOMS clients if provided by user
if [ -z $VOMSREPO ]; then
  echo "No clients repo provided. Installing default version (EMI3)"
else
  wget "$VOMSREPO" -O /etc/yum.repos.d/vomsclients.repo
  if [ $? !=0 ]; then
    echo "A problem occurred when downloading the provided repo. Installing default version (EMI3)"
  fi
fi

yum install -y voms-clients3
yum install -y myproxy


# install and execute the VOMS testsuite as user "voms"
sudo -u voms -- sh -c "git clone $TESTSUITE; cd /home/voms/voms-testsuite; pybot --variable vo1_host:$VO_HOST --variable vo1:$VO --variable vo1_issuer:$VO_ISSUER --pythonpath lib -d reports tests/clients"

