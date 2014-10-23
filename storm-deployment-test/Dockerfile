FROM centos6/puppetbase:1.0

#install the list of puppet modules after downloading from github
run git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules

#install all puppet modules required by the StoRM testsuite
add manifest.pp /
run puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp

# install acl and extended attributes support
run yum install -y attr
run yum install -y acl

# expose StoRM ports
expose 8080 8085 8086 8443 8444 9998

# install clients setup script
add deploy.sh /
run chmod +x /deploy.sh

# add StoRM daemons 
add daemons /daemons
run chmod -R +x /daemons

# add StoRM deployment scripts
add deployment-scripts /deployment-scripts

# add StoRM host certificate
add storm-certificates /storm-certificates

# area for containers synchronization
volume ["/opt"]

