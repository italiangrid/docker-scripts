#!/bin/bash

#install the list of puppet modules after downloading from github
git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules

#install all puppet modules required by the StoRM testsuite
puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp

# install acl and extended attributes support
yum install -y attr acl

