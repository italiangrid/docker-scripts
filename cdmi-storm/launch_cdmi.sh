#!/bin/bash
set -x

STORM_BACKEND_HOST="${STORM_BACKEND_HOST:-docker-storm.cnaf.infn.it}"
STORM_XMLRPC_TOKEN="${STORM_XMLRPC_TOKEN:-NS4kYAZuR65XJCq}"
REDIS_HOSTNAME="${REDIS_HOSTNAME:-localhost}"

if [ -z ${CLIENT_ID+x} ]; then echo "CLIENT_ID is unset"; exit 1; fi

if [ -z ${CLIENT_SECRET+x} ]; then echo "CLIENT_SECRET is unset"; exit 1; fi

cd /etc/cdmi-server/plugins
sed -i 's/STORM_BACKEND_HOST/${STORM_BACKEND_HOST}/g' storm-properties.yml
sed -i 's/STORM_XMLRPC_TOKEN/${STORM_XMLRPC_TOKEN}/g' storm-properties.yml

cd /var/lib/cdmi-server/config
sed -i 's/CLIENT_ID/${CLIENT_ID}/g' application.yml
sed -i 's/CLIENT_SECRET/${CLIENT_SECRET}/g' application.yml
sed -i 's/REDIS_HOSTNAME/${REDIS_HOSTNAME}/g' application.yml

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
