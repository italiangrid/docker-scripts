#!/bin/bash

#install the list of puppet modules after downloading from github
git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules

#install all puppet modules required by the VOMS testsuite
puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp

# install utilities
yum install -y fetch-crl dcache-srmclient

# run fetch-crl
fetch-crl

# setup for the voms user
adduser -d /home/voms voms
mkdir /home/voms/.globus
chown -R voms.voms /home/voms/.globus

chmod +x /setup_clients.sh
