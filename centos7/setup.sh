#!/bin/sh
set -ex

yum clean all
yum install -y hostname epel-release
yum -y update
yum -y install wget tar puppet git

puppet module install --force maestrodev-wget
puppet module install --force gini-archive
puppet module install --force puppetlabs-stdlib
puppet module install --force puppetlabs-java

git clone https://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules
puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp
