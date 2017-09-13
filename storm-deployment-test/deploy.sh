#!/bin/bash
set -x

MODE="${MODE:-"clean"}"
PLATFORM="${PLATFORM:-"centos6"}"
DEPLOYMENT_SCRIPT="$MODE-deployment_$PLATFORM.sh"

STORM_DEPLOYMENT_TEST_BRANCH=${STORM_DEPLOYMENT_TEST_BRANCH:-"master"}

cd /
git clone https://github.com/italiangrid/storm-deployment-test.git --branch $STORM_DEPLOYMENT_TEST_BRANCH
cd /storm-deployment-test/docker

chmod +x $DEPLOYMENT_SCRIPT
./$DEPLOYMENT_SCRIPT

# disable frontend monitor
sed -i -e '/monitoring.enabled=true/c\monitoring.enabled=false' /etc/storm/frontend-server/storm-frontend-server.conf

sh /daemons/frontend
