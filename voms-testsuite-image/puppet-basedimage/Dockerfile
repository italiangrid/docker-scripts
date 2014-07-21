FROM    centos:centos6

#update the image
run yum update -y

# install basic tools and epel repo
run yum install -y wget git tar which http://yum.puppetlabs.com/el/6.4/products/x86_64/puppetlabs-release-6-7.noarch.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm epel-release-6*.rpm redhat-lsb

# install puppet
run yum --enablerepo=centosplus install -y puppet

# install basic puppet modules
run puppet module install --force maestrodev-wget
run puppet module install --force gini-archive
run puppet module install --force puppetlabs-stdlib

