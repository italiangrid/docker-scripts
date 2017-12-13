#!/bin/bash

set -xe

CODE_DIR=${CODE_DIR:-/opt/code}
VERSION=${VERSION:-0.0.1-SNAPSHOT}

# Get Puppet modules
if [ ! -d /opt/ci-puppet-modules ]; then
  git clone https://github.com/cnaf/ci-puppet-modules.git /opt/ci-puppet-modules
fi

# Configure
/opt/puppetlabs/bin/puppet module install puppetlabs-stdlib

/opt/puppetlabs/bin/puppet apply --modulepath=/etc/puppetlabs/code/environments/production/modules/:/opt/ci-puppet-modules/modules/ /manifest.pp && \
grep -q 'failure: 0' /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml

jarfile="oidc-client-${VERSION}.jar"
JARFILEPATH="${CODE_DIR}/argus-oidc-client/oidc-client/target/${jarfile}"

cp ${JARFILEPATH} .

DEBUG_OPTS=""
#SSL_DEBUG="-Djavax.net.debug=ssl,handshake"
SSL_DEBUG_OPT=${SSL_DEBUG_OPT:-""}
DEBUG_SUSPEND=${DEBUG_SUSPEND:-"n"}

if [ ! -z "$ENABLE_DEBUG" ] && [ "$ENABLE_DEBUG" == 'y' ] && [ ! -z "$DEBUG_PORT" ]; then
	DEBUG_OPTS="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=${DEBUG_PORT},suspend=${DEBUG_SUSPEND}"
fi

JAVA_OPTS="-Dspring.profiles.active=prod -Djava.security.egd=file:/dev/urandom ${DEBUG_OPTS} ${SSL_DEBUG_OPT}"
java ${JAVA_OPTS} -jar ${jarfile} 
