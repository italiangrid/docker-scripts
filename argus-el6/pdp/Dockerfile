FROM italiangrid/base-dev:latest

# Layer: base
RUN rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm && \
    yum install -y http://repository.egi.eu/sw/production/umd/3/sl6/x86_64/base/umd-release-3.0.0-1.el6.noarch.rpm && \
    yum update -y && yum install -y git puppet redhat-lsb

# Layer: Argus PDP
EXPOSE 8152
EXPOSE 8153

COPY run.sh /
COPY manifest.pp /

CMD /run.sh