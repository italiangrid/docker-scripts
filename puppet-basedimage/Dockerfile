FROM    centos:centos6

# install gpg keys
rpm --import http://mirror.centos.org/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6
rpm --import http://mirror.centos.org/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-Debug-6
rpm --import http://mirror.centos.org/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-Testing-6
rpm --import http://mirror.centos.org/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-Security-6

# install epel
run rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

#update the image
run yum update -y

# install basic tools and puppet
run yum --enablerepo=centosplus install -y puppet redhat-lsb wget git tar


# install basic puppet modules
run puppet module install --force maestrodev-wget
run puppet module install --force gini-archive
run puppet module install --force puppetlabs-stdlib

