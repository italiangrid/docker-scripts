FROM    centos:centos6

# install epel
run rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

#update the image
run yum update -y

# install basic tools and puppet
run yum --enablerepo=centosplus install -y puppet redhat-lsb wget git tar


# install basic puppet modules
run puppet module install --force maestrodev-wget
run puppet module install --force gini-archive
run puppet module install --force puppetlabs-stdlib

