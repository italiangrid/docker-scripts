#!/bin/bash

# install the list of puppet modules after downloading from github
git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules

# install all puppet modules required by the StoRM testsuite. 
# the "--detailed-exitcodes" flag returns explicit exit status:
# exit code '2' means there were changes
# exit code '4' means there were failures during the transaction
# exit code '6' means there were both changes and failures
puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ --detailed-exitcodes /manifest.pp

# check if errors occurred after puppet apply:
if [[ ( $? -eq 4 ) || ( $? -eq 6 ) ]]; then
  exit 1
fi

# install utilities
yum install -y fetch-crl nc

# run fetch-crl
fetch-crl

# check if errors occurred after fetch-crl execution
if [ $? != 0 ]; then
  exit 1
fi

pip install --upgrade robotframework-httplibrary

# install clients
yum install -y voms-clients3 myproxy

echo 'export X509_USER_PROXY="/tmp/x509up_u$(id -u)"'>/etc/profile.d/x509_user_proxy.sh
