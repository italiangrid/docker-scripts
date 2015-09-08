#!/bin/bash

# some variables
CONFDIR=/etc/storm
SITEINFODIR=$CONFDIR/siteinfo
VODIR=$SITEINFODIR/vo.d
JARDIR=/usr/share/java/storm-webdav
REPO="https://github.com/italiangrid/storm-deployment-test/raw/master"
KEYDIR=/etc/grid-security
SRVKEYDIR=$KEYDIR/storm-webdav

STORM_FILE_LIST="storm-groups.conf storm-users.conf storm-wn-list.conf"
VO_FILE_LIST="test.vo testers.eu-emi.eu"
JVM_OPTS=""
TARFILE="target/storm-webdav-server.tar.gz"

set -ex

# clean
rm -f $JARDIR/*.jar

ls -l /code

# new code
tar -C / -xvzf /code/$TARFILE

ls -l /etc/storm/webdav/sa.d

# setup
if [ ! -d $KEYDIR/vomsdir ]; then
  mkdir -p $KEYDIR/vomsdir
fi

fetch-crl

if [ ! -d $SRVKEYDIR ]; then
  mkdir -p $SRVKEYDIR
fi

cp $KEYDIR/hostcert.pem $KEYDIR/hostkey.pem $SRVKEYDIR/
chown -R storm:storm $SRVKEYDIR

puppet apply --modulepath=/ci-puppet-modules/modules/ /ci-puppet-modules/modules/puppet-test-vos/manifests/init.pp

# get test configuration
if [ ! -d $VODIR ]; then
  mkdir -p $VODIR
fi

for file in $STORM_FILE_LIST; do
  wget "$REPO/siteinfo/$file" -P $SITEINFODIR
done

for file in $VO_FILE_LIST; do
  wget "$REPO/siteinfo/vo.d/$file" -P $VODIR
done

# start service
if [ -n "$ENABLE_JREBEL" ]; then
  JVM_OPTS="-javaagent:/jrebel/jrebel.jar -Drebel.stats=false -Drebel.usage_reporting=false -Drebel.struts2_plugin=true -Drebel.tiles2_plugin=true $JVM_OPTS"
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

