#!/bin/bash

TESTSUITE="${TESTSUITE:-git://github.com/italiangrid/grinder-load-testsuite.git}"
TESTSUITE_TEST_NAME="${TESTSUITE_TEST_NAME:-ptg-sync}"
TESTSUITE_BRANCH="${TESTSUITE_BRANCH:-master}"
TESTSUITE_STORAGE_AREA="${TESTSUITE_STORAGE_AREA:-test.vo}"
TESTSUITE_VO_NAME="${TESTSUITE_VO_NAME:-test.vo}"

STORM_BE_HOSTNAME="${STORM_BE_HOSTNAME:-docker-storm.cnaf.infn.it}"
STORM_FE_ENDPOINT_LIST="${STORM_FE_ENDPOINT_LIST:-${STORM_BE_HOSTNAME}:8444}"
STORM_DAV_ENDPOINT_LIST="${STORM_DAV_ENDPOINT_LIST:-${STORM_BE_HOSTNAME}:8443}"

GRINDER_PROCESSES="${GRINDER_PROCESSES:-4}"
GRINDER_THREADS="${GRINDER_THREADS:-10}"
GRINDER_RUNS="${GRINDER_RUNS:-0}"
GRINDER_USE_CONSOLE="${GRINDER_USE_CONSOLE:-true}"
GRINDER_CONSOLE_HOST="${GRINDER_CONSOLE_HOST:-dot1x-179.cnaf.infn.it}"

PASSWORD=pass

MAX_RETRIES=600

attempts=1

CMD="nc -z ${STORM_BE_HOSTNAME} 8444"

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

cmd="git clone $TESTSUITE; \
	cd /home/tester/grinder-load-testsuite; \
	git checkout $TESTSUITE_BRANCH; \
	export GRINDER_PROCESSES=$GRINDER_PROCESSES; \
	export GRINDER_THREADS=$GRINDER_THREADS; \
	export GRINDER_USE_CONSOLE=$GRINDER_USE_CONSOLE; \
	export GRINDER_CONSOLE_HOST=$GRINDER_CONSOLE_HOST; \
	export GRINDER_RUNS=$GRINDER_RUNS; \
	export STORM_BE_HOSTNAME=$STORM_BE_HOSTNAME; \
	export STORM_FE_ENDPOINT_LIST=$STORM_FE_ENDPOINT_LIST; \
	export STORM_DAV_ENDPOINT_LIST=$STORM_DAV_ENDPOINT_LIST; \
	export TESTSUITE_STORAGE_AREA=$TESTSUITE_STORAGE_AREA; \
	rm -f log/*; \
	./bin/runAgent.sh ./storm/$TESTSUITE_TEST_NAME/test.properties;"

echo "$cmd"

# install and execute the StoRM load testsuite as user "tester"
exec su - tester sh -c "echo $PASSWORD|voms-proxy-init -pwstdin --voms $TESTSUITE_VO_NAME; $cmd"
