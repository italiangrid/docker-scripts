FROM centos:7

ARG CLIENT_ID
ARG CLIENT_SECRET

ENV CLIENT_ID=$CLIENT_ID
ENV CLIENT_SECRET=$CLIENT_SECRET

RUN yum update -y
RUN yum install -y wget git

#RUN rpm --import http://repo.indigo-datacloud.eu/repository/RPM-GPG-KEY-indigodc
#WORKDIR /etc/yum.repos.d
#RUN wget http://repo.indigo-datacloud.eu/repos/2/indigo2.repo
#RUN yum install -y cdmi-server

RUN wget https://ci.cloud.cnaf.infn.it/view/storm/job/CDMI/lastSuccessfulBuild/artifact/cdmi-server-1.2-1.fc25.x86_64.rpm
RUN yum localinstall -y cdmi-server-1.2-1.fc25.x86_64.rpm

COPY launch_cdmi.sh /launch_cdmi.sh
RUN chmod +x /launch_cdmi.sh

RUN yum install -y nc

EXPOSE 8888

ENTRYPOINT ["/launch_cdmi.sh"]