#!/bin/bash

TESTSUITE="${TESTSUITE:-git://github.com/italiangrid/storm-testsuite.git}"
STORM_BE_HOST="${STORM_BE_HOST:-docker-storm.cnaf.infn.it}"
TESTSUITE_BRANCH="${TESTSUITE_BRANCH:-develop}"
TAGS_TO_EXCLUDE="${TAGS_TO_EXCLUDE:-to-be-fixed}"
TESTSUITE_TESTS="${TESTSUITE_TESTS:-tests}"

echo 'export X509_USER_PROXY="/tmp/x509up_u$(id -u)"'>/etc/profile.d/x509_user_proxy.sh

MAX_RETRIES=600

attempts=1

CMD="nc -z ${STORM_BE_HOST} 8444"

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

tags=(`echo $TAGS_TO_EXCLUDE | tr " " "\n"`)
exclude_str=""
for tag in "${tags[@]}"
do
  exclude_str="$exclude_str --exclude $tag"
done

# install and execute the StoRM testsuite (develop version) as user "tester"
exec su - tester sh -c "git clone $TESTSUITE; cd /home/tester/storm-testsuite; git checkout $TESTSUITE_BRANCH; pybot --pythonpath lib --variable backEndHost:$STORM_BE_HOST $exclude_str -d reports $TESTSUITE_TESTS"

