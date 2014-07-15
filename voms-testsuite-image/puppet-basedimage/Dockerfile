FROM    centos:centos6

# install basic tools
run yum install -y which
run yum install -y wget
run yum install -y tar
run yum install -y git

# install puppet
run yum install -y http://yum.puppetlabs.com/el/6.4/products/x86_64/puppetlabs-release-6-7.noarch.rpm
run yum --enablerepo=centosplus install -y puppet

# install basic puppet modules
run puppet module install --force maestrodev-wget
run puppet module install --force gini-archive
run puppet module install --force puppetlabs-stdlib

# install epel repo
run wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
run wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
run yum -y install remi-release-6*.rpm epel-release-6*.rpm

# facter related
run yum install -y redhat-lsb
