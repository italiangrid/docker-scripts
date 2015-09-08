FROM italiangrid/base-dev

RUN \
  yum update -y && \
  yum install -y fetch-crl attr acl storm-webdav

ADD setup /
RUN chmod 755 "/run.sh"

CMD /run.sh
