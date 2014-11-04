FROM    centos:centos6

run \
  rpm --import http://mirror.centos.org/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6 && \
  rpm --import http://mirror.centos.org/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-Debug-6 && \
  rpm --import http://mirror.centos.org/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-Testing-6 && \
  rpm --import http://mirror.centos.org/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-Security-6 && \
  rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
  yum clean all && \
  yum -y update && \
  yum --enablerepo=centosplus install -y puppet redhat-lsb wget git tar && \
  puppet module install --force maestrodev-wget && \
  puppet module install --force gini-archive && \
  puppet module install --force puppetlabs-stdlib
