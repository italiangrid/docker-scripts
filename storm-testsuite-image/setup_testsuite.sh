#!/bin/bash
set -x

TESTSUITE="${TESTSUITE:-git://github.com/italiangrid/storm-testsuite.git}"
STORM_BE_HOST="${STORM_BE_HOST:-docker-storm.cnaf.infn.it}"

echo 'export X509_USER_PROXY="/tmp/x509up_u$(id -u)"'>/etc/profile.d/x509_user_proxy.sh

# install and execute the StoRM testsuite (develop version) as user "tester"
exec su - tester sh -c "git clone $TESTSUITE; cd /home/tester/storm-testsuite; git checkout develop; pybot --pythonpath lib --variable backEndHost:$STORM_BE_HOST --exclude to-be-fixed -d reports tests"

