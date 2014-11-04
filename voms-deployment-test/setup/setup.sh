#!/bin/bash
set -ex

## Setup host certificate
mkdir -p /etc/grid-security
cp /voms_server.cert.pem /etc/grid-security/hostcert.pem
cp /voms_server.key.pem /etc/grid-security/hostkey.pem
chmod 400 /voms_server.key.pem /etc/grid-security/hostkey.pem

## Run puppet
git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules
puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp

chmod +x /run.sh
## Clean things up
yum clean all
