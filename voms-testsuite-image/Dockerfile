FROM italiangrid/base

add manifest.pp /

run git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules && \
  puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp && \
  yum install -y fetch-crl java-1.6.0-openjdk-devel && \
  adduser -d /home/voms voms

user voms
run mkdir /home/voms/.globus

user root
workdir /home/voms

# install setup client script
add setup.sh /
run chmod +x /setup.sh

CMD /setup.sh
