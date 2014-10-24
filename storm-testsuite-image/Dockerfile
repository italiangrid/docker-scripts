FROM	centos6/puppetbase:1.0

#install the list of puppet modules after downloading from github
run git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules

#install all puppet modules required by the StoRM testsuite
add manifest.pp /
run puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp

# install netcat
run yum install -y nc

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

# install clients
run yum install -y voms-clients3
run yum install -y myproxy

add setup_testsuite.sh /
run chmod +x /setup_testsuite.sh
entrypoint /setup_testsuite.sh

