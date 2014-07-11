FROM	centos:6.4

# install librarian-puppet
run yum install -y which
run yum install -y git
run curl -L get.rvm.io | bash -s stable
run /bin/bash -c 'source /etc/profile.d/rvm.sh; rvm requirements; rvm install 1.9.3; rvm use 1.9.3 --default; rvm rubygems current; gem install puppet librarian-puppet -N -V'

#install puppet
run yum -y install http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
run yum -y install puppet

run yum install -y redhat-lsb
run puppet module install --force maestrodev-wget
run puppet module install --force gini-archive
run puppet module install --force puppetlabs-stdlib

#install the list of puppet modules after downloading from github
add Puppetfile /
run /bin/bash -c 'source /etc/profile.d/rvm.sh;librarian-puppet install'

#install useful repos
run puppet apply --modulepath=/modules:/etc/puppet/modules/ -e "class { 'puppet-emi3-release': }"
run puppet apply --modulepath=/modules:/etc/puppet/modules/ -e "class { 'puppet-test-ca': }"
run puppet apply --modulepath=/modules:/etc/puppet/modules/ -e "class { 'puppet-infn-ca': }"

# install robotframework
run puppet apply --modulepath=/modules:/etc/puppet/modules/ -e "class { 'puppet-robot-framework': }"

# install test-ca
run yum install -y igi-test-ca
run yum install -y igi-test-ca-256

# install INFNCA
run yum install -y ca_INFN-CA-2006

# install epel repo
run wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
run wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
run yum -y install remi-release-6*.rpm epel-release-6*.rpm

# install fetch-crl
run yum install -y fetch-crl
run fetch-crl

# setup voms dirs and install latest VOMS-clients
run puppet apply --modulepath=/modules:/etc/puppet/modules/ -e "class { 'puppet-voms::install-clients': }"
run puppet apply --modulepath=/modules:/etc/puppet/modules/ -e "class { 'puppet-test-vos': }"

# install myproxy
run yum -y install myproxy

# install dcache clients
run yum -y install dcache-srmclient

# install git
run yum install -y git

# setup for the  voms user
run adduser -d /home/voms voms
user voms
workdir /home/voms
env HOME /home/voms
run mkdir .globus

# install VOMS testsuite
run git clone git://github.com/italiangrid/voms-testsuite.git
workdir /home/voms/voms-testsuite

