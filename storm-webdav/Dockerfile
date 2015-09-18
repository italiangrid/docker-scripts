FROM italiangrid/base-dev

RUN \
  yum update -y && \
  yum install -y fetch-crl attr acl storm-webdav

COPY files/manifest.pp /
RUN puppet apply --modulepath=/ci-puppet-modules/modules/:/etc/puppet/modules/ /manifest.pp

COPY setup /
RUN chmod 755 "/run.sh"

CMD /run.sh
