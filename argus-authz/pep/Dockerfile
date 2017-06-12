FROM italiangrid/base-dev-centos7:latest

# Layer: base
RUN	yum install -y http://linuxsoft.cern.ch/wlcg/centos7/x86_64/wlcg-repo-1.0.0-1.el7.noarch.rpm && \
	yum install -y http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/base/umd-release-4.0.0-1.el7.noarch.rpm && \
    yum install -y git puppet redhat-lsb && \
    yum clean all

# Layer: Argus PEP
EXPOSE 8154
EXPOSE 8155

COPY run.sh /
RUN chmod +x /run.sh

COPY manifest.pp /

COPY vo-ca-ap-file /etc/grid-security
COPY policy-*.info /etc/grid-security/certificates/

CMD /run.sh