FROM italiangrid/base-dev-centos7:latest

# Layer: base
RUN	yum install -y http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/base/umd-release-4.0.0-1.el7.noarch.rpm && \
    yum install -y https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm && \
    yum install -y git puppet-agent redhat-lsb && \
    yum clean all

# Layer: Argus BDII
EXPOSE 2170

COPY run.sh /
RUN chmod +x /run.sh

COPY manifest.pp /

CMD /run.sh
