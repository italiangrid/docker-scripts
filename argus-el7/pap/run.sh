#!/bin/bash

set -xe

CODE_DIR=${CODE_DIR:-/opt/code}
PAP_LIBS=/usr/share/argus/pap/lib

# Get Puppet modules
cd /opt
rm -rfv *puppet*

git clone https://github.com/cnaf/ci-puppet-modules.git
git clone https://github.com/marcocaberletti/puppet.git

# Configure
puppet apply --modulepath=/opt/ci-puppet-modules/modules/:/opt/puppet/modules/:/etc/puppet/module/ /manifest.pp

cd /

TARFILE=$CODE_DIR/argus-pap/target/argus-pap.tar.gz

## Clean and install new code
if [ -f $TARFILE ]; then
	ls -l $CODE_DIR
	find $PAP_LIBS/ -iname '*.jar' -exec rm -f '{}' \;
	tar -C / -xvzf $TARFILE

	# reconfigure
	puppet apply --modulepath=/opt/ci-puppet-modules/modules/:/opt/puppet/modules/:/etc/puppet/module/ /manifest.pp
fi

# Run
source /etc/sysconfig/argus-pap

LOCALCP=`ls $PAP_LIBS/provided/*.jar | xargs | tr ' ' ':'`
CLASSPATH=$LOCALCP:`ls $PAP_LIBS/*.jar | xargs | tr ' ' ':'`

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

java $JMX_OPT $DEBUG_OPT $JREBEL_OPT $PAP_JAVA_OPTS -DPAP_HOME=$PAP_HOME \
	-Djava.endorsed.dirs=$PAP_LIBS/endorsed \
	-cp $CLASSPATH:$PAP_HOME/conf/logging/standalone \
	org.glite.authz.pap.server.standalone.PAPServer \
	--conf-dir $PAP_HOME/conf &

sleep 5

tail -f /var/log/argus/pap/*.log