FROM	centos6/puppetbase:1.0

#install the list of puppet modules after downloading from github
add get_puppet_modules.sh /
run ./get_puppet_modules.sh

run yum install -y sudo
  
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

# install fetch-crl
run yum install -y fetch-crl
run fetch-crl

# setup voms dirs 
run puppet apply --modulepath=/modules:/etc/puppet/modules/ -e "class { 'puppet-test-vos': }"

# install dcache clients
run yum -y install dcache-srmclient

# install git
run yum install -y git

# setup for the  voms user
run adduser -d /home/voms voms
user voms
run mkdir /home/voms/.globus
user root
workdir /home/voms

# install clients setup script
add setup_clients.sh /
run chmod +x /setup_clients.sh
cmd /setup_clients.sh

