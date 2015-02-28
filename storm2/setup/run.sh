#!/bin/bash
set -ex

echo "STORM_JAR: $STORM_JAR"

if [ -z "$STORM_JAR" ]; then
  echo "Please set the STORM_JAR env variable."
  exit 1
fi

groupadd -r storm
useradd storm -g storm

chown storm:storm /etc/grid-security/hostcert.pem
chown storm:storm /etc/grid-security/hostkey.pem

# Set log levels
STORM_LOG_LEVEL=${STORM_LOG_LEVEL:-INFO}
JAVA_LOG_LEVEL=${JAVA_LOG_LEVEL:-ERROR}
STORM_JAVA_OPTS="-DSTORM_LOG_LEVEL=${STORM_LOG_LEVEL} -DJAVA_LOG_LEVEL=${JAVA_LOG_LEVEL} $STORM_JAVA_OPTS"

if [ -n "$ENABLE_JREBEL" ]; then
    STORM_JAVA_OPTS="-javaagent:/jrebel/jrebel.jar -Drebel.stats=false -Drebel.usage_reporting=false $STORM_JAVA_OPTS"
fi

if [ -z "$STORM_DEBUG_PORT" ]; then
  STORM_DEBUG_PORT=1044
fi

if [ -z "$STORM_DEBUG_SUSPEND" ]; then
  STORM_DEBUG_SUSPEND="n"
fi

if [ ! -z "$STORM_DEBUG" ]; then
  STORM_JAVA_OPTS="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=$STORM_DEBUG_PORT,suspend=$STORM_DEBUG_SUSPEND $STORM_JAVA_OPTS"
fi

mkdir /app
cp $STORM_JAR /app
chown -R storm:storm /app

# Start service
su storm -s /bin/bash -c "cd /app && java $STORM_JAVA_OPTS -jar /app/$(basename $STORM_JAR) $STORM_ARGS"
