#!/bin/bash
set -x

# install cdmi_storm
wget $STORM_REPO -O /etc/yum.repos.d/cdmi-storm.repo
yum clean all
yum install -y cdmi-storm

# Configure
if [ -z ${CLIENT_ID+x} ]; then echo "CLIENT_ID is unset"; exit 1; fi
if [ -z ${CLIENT_SECRET+x} ]; then echo "CLIENT_SECRET is unset"; exit 1; fi

STORM_DEPLOYMENT_TEST_BRANCH="${STORM_DEPLOYMENT_TEST_BRANCH:-master}"

cd /
git clone https://github.com/italiangrid/storm-deployment-test.git --branch $STORM_DEPLOYMENT_TEST_BRANCH
cd /storm-deployment-test

cp -rf cdmi/var/lib/cdmi-server/config/application.yml /var/lib/cdmi-server/config/application.yml
cp -rf cdmi/etc/cdmi-server/plugins/capabilities /etc/cdmi-server/plugins/

cd /var/lib/cdmi-server/config
sed -i 's/CLIENT_ID/${CLIENT_ID}/g' application.yml
sed -i 's/CLIENT_SECRET/${CLIENT_SECRET}/g' application.yml

MAX_RETRIES=600
attempts=1
CMD="nc -w1 ${REDIS_HOSTNAME} 6379"

echo "Waiting for Redis server ... "
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

cd /var/lib/cdmi-server
./cdmi-server-1.2.jar
