#!/bin/bash
set -x

TESTSUITE="${TESTSUITE:-git://github.com/italiangrid/storm-testsuite.git}"
TESTSUITE_BRANCH="${TESTSUITE_BRANCH:-develop}"

# Sync port
STORM_BE_SYNC_PORT="${STORM_BE_SYNC_PORT:-8444}"
STORM_BE_HOST="${STORM_BE_HOST:-docker-storm.cnaf.infn.it}"

# Variables
VARIABLES="--variable backEndHost:$STORM_BE_HOST"

CDMI_ENDPOINT="${CDMI_ENDPOINT:-cdmi-storm.cnaf.infn.it:8888}"
VARIABLES="$VARIABLES --variable cdmiEndpoint:$CDMI_ENDPOINT"

CDMI_CLIENT_ID="${CDMI_CLIENT_ID:-838129a5-84ca-4dc4-bfd8-421ee317aabd}"
VARIABLES="$VARIABLES --variable cdmiClientId:$CDMI_CLIENT_ID"

IAM_USER_NAME="${IAM_USER_NAME:-storm_robot_user}"
VARIABLES="$VARIABLES --variable iamUserName:$IAM_USER_NAME"

CDMI_ADMIN_USERNAME=${CDMI_ADMIN_USERNAME:-restadmin}
CDMI_ADMIN_PASSWORD=${CDMI_ADMIN_PASSWORD:-restadmin}
VARIABLES="$VARIABLES --variable cdmiAdminUser:$CDMI_ADMIN_USERNAME"
VARIABLES="$VARIABLES --variable cdmiAdminPassword:$CDMI_ADMIN_PASSWORD"

${iamUserPassword}  secret
${cdmiClientSecret}  secret

if [ -z ${CDMI_CLIENT_SECRET+x} ]; then 
    echo "CDMI_CLIENT_SECRET is unset"; 
else 
    VARIABLES="$VARIABLES --variable cdmiClientSecret:$CDMI_CLIENT_SECRET"
fi

if [ -z ${IAM_USER_PASSWORD+x} ]; then 
    echo "IAM_USER_PASSWORD is unset"; 
else 
    VARIABLES="$VARIABLES --variable iamUserPassword:$IAM_USER_PASSWORD"
fi

# Which tests
TESTSUITE_SUITE="${TESTSUITE_SUITE:-tests}"

MAX_RETRIES=600
attempts=1

CMD="nc -z ${STORM_BE_HOST} ${STORM_BE_SYNC_PORT}"

echo "Waiting for StoRM services... "
$CMD

while [ $? -eq 1 ] && [ $attempts -le  $MAX_RETRIES ];
do
  sleep 5
  let attempts=attempts+1
  $CMD
done

if [ $attempts -gt $MAX_RETRIES ]; then
    echo "Timeout!"
    exit 1
fi

if [ -z "$TESTSUITE_EXCLUDE" ]; then
  EXCLUDE=""
else
  EXCLUDE="--exclude $TESTSUITE_EXCLUDE" 
fi

git clone $TESTSUITE --branch $TESTSUITE_BRANCH
cd storm-testsuite

pybot --pythonpath .:lib $VARIABLES $EXCLUDE -d reports -s $TESTSUITE_SUITE tests