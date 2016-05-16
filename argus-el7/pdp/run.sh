#!/bin/bash

set -xe

CODE_DIR=${CODE_DIR:-/opt/code}

PDP_HOME=/usr/share/argus/pdp
PDP_LIBS=$PDP_HOME/lib

# Get Puppet modules
cd /opt
rm -rfv *puppet*

git clone https://github.com/cnaf/ci-puppet-modules.git
git clone https://github.com/marcocaberletti/puppet.git

# Configure
puppet apply --modulepath=/opt/ci-puppet-modules/modules/:/opt/puppet/modules/:/etc/puppet/module/ /manifest.pp

cd /

TARFILE=$CODE_DIR/argus-pdp/target/argus-pdp*.tar.gz

## Clean and install new code
if [ -f $TARFILE ]; then
	ls -l $CODE_DIR
	find $PDP_LIBS/ -iname '*.jar' -exec rm -f '{}' \;
	tar -C / -xvzf $CODE_DIR/argus-pdp/target/argus-pdp*.tar.gz

	# reconfigure
	puppet apply --modulepath=/opt/ci-puppet-modules/modules/:/opt/puppet/modules/:/etc/puppet/module/ /manifest.pp
fi

# Run
source /etc/sysconfig/argus-pdp

LOCALCP=/usr/share/java/argus-pdp-pep-common.jar:`ls $PDP_LIBS/provided/*.jar | xargs | tr ' ' ':'`
CLASSPATH=$LOCALCP:`ls $PDP_LIBS/*.jar | xargs | tr ' ' ':'`

JMX_OPT=""
DEBUG_OPT=""
JREBEL_OPT=""

if [ ! -z "$ENABLE_JMX" ] && [ "$ENABLE_JMX" == 'y' ] && [ ! -z "$JMX_PORT" ]; then
	JMX_OPT="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=$JMX_PORT -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
fi

if [ ! -z "$ENABLE_DEBUG" ] && [ "$ENABLE_DEBUG" == 'y' ] && [ ! -z "$DEBUG_PORT" ]; then
	DEBUG_OPT="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=$DEBUG_PORT,suspend=n"
fi

if [ ! -z "$ENABLE_JREBEL" ] && [ "$ENABLE_JREBEL" == 'y' ]; then
	JREBEL_OPT="-javaagent:/opt/jrebel/jrebel.jar -Drebel.stats=false -Drebel.usage_reporting=false -Drebel.struts2_plugin=true -Drebel.tiles2_plugin=true"
fi

## wait for PAP before start
set +e
start_ts=$(date +%s)
timeout=300
sleeped=0
while true; do
    (echo > /dev/tcp/$PAP_HOST/$PAP_PORT) >/dev/null 2>&1
    result=$?
    if [[ $result -eq 0 ]]; then
        end_ts=$(date +%s)
        echo "$PAP_HOST:$PAP_PORT is available after $((end_ts - start_ts)) seconds"
        break
    fi
    echo "Waiting for PAP..."
    sleep 5

    sleeped=$((sleeped+5))
    if [ $sleeped -ge $timeout  ]; then
    	echo "Timeout!"
    	exit 1
	fi
done
set -e

java -Dorg.glite.authz.pdp.home=$PDP_HOME \
	-Dorg.glite.authz.pdp.confdir=$PDP_HOME/conf \
	-Dorg.glite.authz.pdp.logdir=$PDP_HOME/logs \
	-Djava.endorsed.dirs=$PDP_HOME/lib/endorsed \
	-classpath $CLASSPATH \
	$PDP_JOPTS $PDP_START_JOPTS $JMX_OPT $DEBUG_OPT $JREBEL_OPT \
	org.glite.authz.pdp.server.PDPDaemon $PDP_HOME/conf/pdp.ini &

sleep 5

tail -f /var/log/argus/pdp/*.log

