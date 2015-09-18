#!/bin/bash

CERT_DIR="/usr/share/igi-test-ca"
PROPFILE="/etc/storm/grinder/testsuite.properties"

get_prop() {

    value=$(grep "$1" $PROPFILE | awk -F'[=&]' '{print $2}' | sed -e "s/^[ \t]*//")
    echo "$value"
}

# proxy

proxy_vo=$(get_prop "proxy.voname")
proxy_user=$(get_prop "proxy.user")

echo "Copy user certificate and key to globus directory ..."
cp $CERT_DIR/$proxy_user.cert.pem /home/tester/.globus/usercert.pem
chmod 644 /home/tester/.globus/usercert.pem
cp $CERT_DIR/$proxy_user.key.pem /home/tester/.globus/userkey.pem
chmod 400 /home/tester/.globus/userkey.pem

echo "Create VOMS proxy for $proxy_vo VO and user $proxy_user ..."
echo pass|voms-proxy-init -pwstdin --voms $proxy_vo

# testsuite

testsuite_repo=$(get_prop "testsuite.repo")
testsuite_branch=$(get_prop "testsuite.branch")

echo "Clone grinder-load-testsuite repository ..."
git clone $testsuite_repo
cd /home/tester/grinder-load-testsuite
git checkout $testsuite_branch

# grinder env

echo "Set GRINDER environment variables ..."
grinder_processes=$(get_prop "grinder.processes")
grinder_threads=$(get_prop "grinder.threads")
grinder_runs=$(get_prop "grinder.runs")
grinder_console=$(get_prop "grinder.console.use")
grinder_console_host=$(get_prop "grinder.console.host")

export GRINDER_PROCESSES=$grinder_processes
export GRINDER_THREADS=$grinder_threads
export GRINDER_USE_CONSOLE=$grinder_console
export GRINDER_CONSOLE_HOST=$grinder_console_host
export GRINDER_RUNS=$grinder_runs

env | grep "GRINDER"

echo "Copy testsuite.properties file ..."
cp $PROPFILE .

echo "Run load testsuite ..."
./bin/runAgent.sh testsuite.properties

