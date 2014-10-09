FROM	centos6/puppetbase:1.0

#install the list of puppet modules after downloading from github
add get_puppet_modules.sh /
run ./get_puppet_modules.sh

#install all puppet modules required by the StoRM testsuite
add manifest.pp /
run puppet apply --modulepath=/modules:/etc/puppet/modules/ /manifest.pp

# install fetch-crl
run yum install -y fetch-crl

# run fetch-crl
run fetch-crl

# setup for the tester user
run adduser -d /home/tester tester
user tester
run mkdir /home/tester/.globus
user root
workdir /home/tester

# install clients setup script
add setup_clients.sh /
run chmod +x /setup_clients.sh
entrypoint /setup_clients.sh

