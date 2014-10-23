#!/bin/bash
set -ex

WGET="wget --no-check-certificate"
DEPLOYMENT_TEST_SCRIPT=${DEPLOYMENT_TEST_SCRIPT:-https://raw.github.com/italiangrid/voms-deployment-test/master/voms-deployment-test.sh}

## Setup host certificate
mkdir -p /etc/grid-security
cp /voms_server.cert.pem /etc/grid-security/hostcert.pem
cp /voms_server.key.pem /etc/grid-security/hostkey.pem
chmod 400 /voms_server.key.pem /etc/grid-security/hostkey.pem

## Run puppet
git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules
puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp

# Fetch deployment test script
wget --no-check-certificate ${DEPLOYMENT_TEST_SCRIPT} \
  -O /voms-deployment-test.sh

chmod +x /voms-deployment-test.sh

## Clean things up
yum clean all
