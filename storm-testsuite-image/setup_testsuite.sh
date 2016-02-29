#!/bin/bash
set -x

TESTSUITE="${TESTSUITE:-git://github.com/italiangrid/storm-testsuite.git}"
STORM_BE_HOST="${STORM_BE_HOST:-docker-storm.cnaf.infn.it}"
STORM_BE_SYNC_PORT="${STORM_BE_SYNC_PORT:-8444}"
TESTSUITE_BRANCH="${TESTSUITE_BRANCH:-develop}"
TESTSUITE_SUITE="${TESTSUITE_SUITE:-tests}"
FS_TYPE="${FS_TYPE:-ext4}"

echo 'export X509_USER_PROXY="/tmp/x509up_u$(id -u)"'>/etc/profile.d/x509_user_proxy.sh

# Run fetch-crl
fetch-crl

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

pybot_cmd="pybot --pythonpath .:lib --variable backEndHost:$STORM_BE_HOST $EXCLUDE --variable fsType:$FS_TYPE -d reports -s $TESTSUITE_SUITE tests"

# install and execute the StoRM testsuite (develop version) as user "tester"
exec su - tester sh -c "git clone $TESTSUITE; cd /home/tester/storm-testsuite; git checkout $TESTSUITE_BRANCH; $pybot_cmd"
