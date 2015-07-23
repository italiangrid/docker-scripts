#!/bin/bash

### Environment variables

TESTSUITE_REPO="${TESTSUITE_REPO:-git://github.com/italiangrid/grinder-load-testsuite.git}"
TESTSUITE_BRANCH="${TESTSUITE_BRANCH:-master}"
TESTSUITE_TEST_VONAME="${TESTSUITE_TEST_VONAME:-test.vo}"
TESTSUITE_PROPFILE_FILENAME="${TESTSUITE_PROPFILE_FILENAME:-testsuite.properties}"

GRINDER_PROCESSES="${GRINDER_PROCESSES:-4}"
GRINDER_THREADS="${GRINDER_THREADS:-10}"
GRINDER_RUNS="${GRINDER_RUNS:-0}"
GRINDER_USE_CONSOLE="${GRINDER_USE_CONSOLE:-true}"
GRINDER_CONSOLE_HOST="${GRINDER_CONSOLE_HOST:-dot1x-179.cnaf.infn.it}"
GRINDER_LOG_LEVEL="${GRINDER_LOG_LEVEL:-info}"
WORKER_LOG_LEVEL="${WORKER_LOG_LEVEL:-warn}"

### Local variables

PROPFILEPATH=/etc/storm/grinder/$TESTSUITE_PROPFILE_FILENAME
echo "propfilepath: $PROPFILEPATH"

PASSWORD=pass

vomsproxy_cmd="echo $PASSWORD|voms-proxy-init -pwstdin --voms $TESTSUITE_TEST_VONAME"

testsuite_cmd="git clone $TESTSUITE_REPO; \
	cd /home/tester/grinder-load-testsuite; \
	git checkout $TESTSUITE_BRANCH; \
	export GRINDER_PROCESSES=$GRINDER_PROCESSES; \
	export GRINDER_THREADS=$GRINDER_THREADS; \
	export GRINDER_USE_CONSOLE=$GRINDER_USE_CONSOLE; \
	export GRINDER_CONSOLE_HOST=$GRINDER_CONSOLE_HOST; \
	export GRINDER_RUNS=$GRINDER_RUNS; \
	export GRINDER_LOG_LEVEL=$GRINDER_LOG_LEVEL; \
	export WORKER_LOG_LEVEL=$WORKER_LOG_LEVEL; \
	rm -f log/*; \
    cp $PROPFILEPATH .; \
	./bin/runAgent.sh $TESTSUITE_PROPFILE_FILENAME;"

# install and execute the StoRM load testsuite as user "tester"
exec su - tester sh -c "$vomsproxy_cmd; $testsuite_cmd"
