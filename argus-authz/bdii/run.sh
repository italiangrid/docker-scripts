#!/bin/bash

set -xe

# Get Puppet modules
if [ ! -d /opt/ci-puppet-modules ]; then
  git clone https://github.com/cnaf/ci-puppet-modules.git /opt/ci-puppet-modules
fi

if [ ! -d /opt/argus-mw-devel ]; then
  git clone https://github.com/argus-authz/argus-mw-devel /opt/argus-mw-devel
  cd /opt/argus-mw-devel/mwdevel_argus
  /opt/puppetlabs/bin/puppet module build
fi

# Configure
/opt/puppetlabs/bin/puppet module install /opt/argus-mw-devel/mwdevel_argus/pkg/mwdevel-mwdevel_argus-*.tar.gz

/opt/puppetlabs/bin/puppet apply --modulepath=/opt/ci-puppet-modules/modules:/etc/puppetlabs/code/environments/production/modules /manifest.pp && \
grep -q 'failure: 0' /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml

cd /

/etc/init.d/bdii restart

sleep 5

tail -f /var/log/bdii/bdii-update.log
