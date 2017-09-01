FROM centos:7

RUN yum update -y
RUN yum install -y wget git

#RUN rpm --import http://repo.indigo-datacloud.eu/repository/RPM-GPG-KEY-indigodc
#WORKDIR /etc/yum.repos.d
#RUN wget http://repo.indigo-datacloud.eu/repos/2/indigo2.repo
#RUN yum install -y cdmi-server

RUN wget https://ci.cloud.cnaf.infn.it/job/CDMI/lastSuccessfulBuild/artifact/cdmi-server.rpm
RUN yum localinstall -y cdmi-server.rpm

COPY launch_cdmi.sh /launch_cdmi.sh
RUN chmod +x /launch_cdmi.sh

RUN yum install -y nc && yum clean all

EXPOSE 8888

ENTRYPOINT ["/launch_cdmi.sh"]