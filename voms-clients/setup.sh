#!/bin/bash
set -x

env

git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules

puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp

yum -y install fetch-crl ca-policy-egi-core \
  java-1.7.0-openjdk-devel java-1.8.0-openjdk-devel \
  java-1.6.0-openjdk-devel \
  voms-clients voms-clients3 voms-admin-client \
  myproxy

fetch-crl

## Print out voms clients version
voms-proxy-init --version

adduser -d /home/voms voms
mkdir /home/voms/.globus
chown -R voms:voms /home/voms
