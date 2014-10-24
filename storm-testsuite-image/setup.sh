#!/bin/bash

#install the list of puppet modules after downloading from github
git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules

#install all puppet modules required by the StoRM testsuite
puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp

# install utilities
yum install -y fetch-crl nc

# run fetch-crl
fetch-crl

# install clients
yum install -y voms-clients3 myproxy

# setup for the tester user
adduser -d /home/tester tester
mkdir /home/tester/.globus
chown -R tester.tester /home/tester/.globus

chmod +x /setup_testsuite.sh

