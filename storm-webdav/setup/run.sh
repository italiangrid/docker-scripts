#!/bin/bash

# some variables
CONFDIR=/etc/storm
SITEINFODIR=$CONFDIR/siteinfo
VODIR=$SITEINFODIR/vo.d
SADIR=$CONFDIR/webdav/sa.d
JARDIR=/usr/share/java/storm-webdav
REPO="https://github.com/italiangrid/storm-deployment-test/raw/master"
KEYDIR=/etc/grid-security
SRVKEYDIR=$KEYDIR/storm-webdav

VO_FILE_LIST="test.vo"
VO_LIST="test.vo dteam igi nested noauth tape testers.eu-emi.eu test.vo.bis"
JVM_OPTS=""
TARFILE="target/storm-webdav-server.tar.gz"

set -ex

# clean
rm -f $JARDIR/*.jar

ls -l /code
tar -C / -xvzf /code/$TARFILE

# setup
fetch-crl

if [ ! -d $SRVKEYDIR ]; then
  mkdir -p $SRVKEYDIR
fi

cp $KEYDIR/hostcert.pem $KEYDIR/hostkey.pem $SRVKEYDIR/
chown -R storm:storm $SRVKEYDIR

# get test configuration
for vo in $VO_LIST; do
  wget --quiet --no-clobber "https://github.com/italiangrid/docker-scripts/raw/master/storm-webdav/files/webdav/sa.d/${vo}.properties" -P $SADIR
done
ls -l $SADIR

for file in $VO_FILE_LIST; do
  wget --quiet "$REPO/siteinfo/vo.d/$file" -P $VODIR
done
ls -l $VODIR

for vo in $VO_LIST; do
  TESTDIR=/storage/$vo/mix-webdav
  if [ ! -d $TESTDIR ];then
    mkdir -p $TESTDIR
  fi
  for n in $(seq 1 5); do
    touch $TESTDIR/file$n
  done
done

chown -R storm:storm /storage

# start service
if [ -n "$ENABLE_JREBEL" ]; then
  JVM_OPTS="-javaagent:/opt/jrebel/jrebel.jar -Drebel.stats=false -Drebel.usage_reporting=false -Drebel.struts2_plugin=true -Drebel.tiles2_plugin=true -Drebel.license=/home/storm/.jrebel/jrebel.lic $JVM_OPTS"
  
  mkdir -p /home/storm
  cp -r /mnt/.jrebel /home/storm
  chown -R storm.storm /home/storm
  chmod 755 /home/storm/.jrebel
  chmod 644 /home/storm/.jrebel/*
fi

if [ -z "$DEBUG_PORT" ]; then
  DEBUG_PORT=1044
fi

if [ -z "$DEBUG_SUSPEND" ]; then
  DEBUG_SUSPEND="n"
fi

if [ ! -z "$DEBUG" ]; then
  JVM_OPTS="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=$DEBUG_PORT,suspend=$DEBUG_SUSPEND $JVM_OPTS"
fi

if [ -n "$ENABLE_JMX" ]; then
  JVM_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=6002 -Dcom.sun.management.jmxremote.rmi.port=6002 -Djava.rmi.server.hostname=dev.local.io -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false $JVM_OPTS"
fi

su storm -s /bin/bash -c "java $JVM_OPTS -jar $JARDIR/storm-webdav-server.jar"

