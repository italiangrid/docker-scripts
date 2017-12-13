FROM centos:7

ENV VERSION=0.0.1-SNAPSHOT

RUN yum install -y https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm && \
    yum install -y java-1.8.0-openjdk-devel puppet-agent redhat-lsb git && \
    yum clean all

# Layer: Argus Oidc client
COPY files/manifest.pp /
COPY files/run.sh /
RUN chmod +x /run.sh

EXPOSE 8156

CMD /run.sh
