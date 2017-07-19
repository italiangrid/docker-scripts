#!/bin/bash
set -x

MODE="${MODE:-clean}"
PLATFORM="${PLATFORM:-centos6}"
STORM_DEPLOYMENT_TEST_BRANCH=${STORM_DEPLOYMENT_TEST_BRANCH:-master}
REDIS_HOSTNAME="${REDIS_HOSTNAME:-localhost}"
CDMI_CLIENT_ID="${CDMI_CLIENT_ID:-838129a5-84ca-4dc4-bfd8-421ee317aabd}"
if [ -z ${CDMI_CLIENT_SECRET+x} ]; then echo "CDMI_CLIENT_SECRET is unset"; exit 1; fi

cd /
git clone https://github.com/italiangrid/storm-deployment-test.git --branch $STORM_DEPLOYMENT_TEST_BRANCH
cd /storm-deployment-test/docker

DEPLOYMENT_SCRIPT="$MODE-cdmi-deployment_$PLATFORM.sh"

export CDMI_CLIENT_ID
export CDMI_CLIENT_SECRET

chmod +x $DEPLOYMENT_SCRIPT
./$DEPLOYMENT_SCRIPT