FROM centos:7

# Layer: base
RUN	yum install -y http://linuxsoft.cern.ch/wlcg/centos7/x86_64/wlcg-repo-1.0.0-1.el7.noarch.rpm && \
	yum install -y http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/base/umd-release-4.0.0-1.el7.noarch.rpm && \
	yum install -y https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm && \
    yum install -y git puppet-agent redhat-lsb java-1.8.0-openjdk-devel && \
    yum clean all

# Layer: Argus PDP
EXPOSE 8152
EXPOSE 8153

COPY files/run.sh /
RUN chmod +x /run.sh

COPY files/manifest.pp /

CMD /run.sh
