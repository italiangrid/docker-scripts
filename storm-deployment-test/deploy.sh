#!/bin/bash
set -x

MODE="${MODE:-clean}"
PLATFORM="${PLATFORM:-centos6}"
STORM_DEPLOYMENT_TEST_BRANCH=${STORM_DEPLOYMENT_TEST_BRANCH:-master}

# install host certificate
cp /storm-certificates/docker_storm_cnaf_infn_it.cert.pem /etc/grid-security/hostcert.pem
cp /storm-certificates/docker_storm_cnaf_infn_it.key.pem /etc/grid-security/hostkey.pem
chmod 400 /etc/grid-security/hostkey.pem
chmod 644 /etc/grid-security/hostcert.pem

# setup StoRM services
service rsyslog start

cd /
git clone https://github.com/italiangrid/storm-deployment-test.git --branch $STORM_DEPLOYMENT_TEST_BRANCH
cd /storm-deployment-test/docker

DEPLOYMENT_SCRIPT="$MODE-deployment_$PLATFORM.sh"

chmod +x $DEPLOYMENT_SCRIPT
./$DEPLOYMENT_SCRIPT

# disable frontend monitor
sed -i -e '/monitoring.enabled=true/c\monitoring.enabled=false' /etc/storm/frontend-server/storm-frontend-server.conf

sh /daemons/frontend
