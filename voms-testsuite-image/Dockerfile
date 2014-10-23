FROM centos6/puppetbase:1.0

add manifest.pp /

run git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules && \
  puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp && \
  yum install -y fetch-crl dcache-srmclient && \
  fetch-crl && \
  adduser -d /home/voms voms

user voms
run mkdir /home/voms/.globus

user root
workdir /home/voms

# install clients setup script
add setup_clients.sh /
run chmod +x /setup_clients.sh
