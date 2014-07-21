FROM	centos6/puppetbase:1.0

#install the list of puppet modules after downloading from github
add get_puppet_modules.sh /
run ./get_puppet_modules.sh

#install all puppet modules required by the VOMS testsuite
add manifest.pp /
run puppet apply --modulepath=/modules:/etc/puppet/modules/ /manifest.pp

# install fetch-crl and dcache clients
run yum install -y fetch-crl dcache-srmclient

# run fetch-crl
run fetch-crl

# setup for the  voms user
run adduser -d /home/voms voms
user voms
run mkdir /home/voms/.globus
user root
workdir /home/voms

# install clients setup script
add setup_clients.sh /
run chmod +x /setup_clients.sh
entrypoint /setup_clients.sh

