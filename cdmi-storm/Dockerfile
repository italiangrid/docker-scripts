FROM centos:7

RUN yum update -y
RUN yum install -y wget git

RUN rpm --import http://repo.indigo-datacloud.eu/repository/RPM-GPG-KEY-indigodc
WORKDIR /etc/yum.repos.d
RUN wget http://repo.indigo-datacloud.eu/repos/2/indigo2.repo
RUN yum install -y cdmi-server

COPY launch_cdmi.sh /launch_cdmi.sh
RUN chmod +x /launch_cdmi.sh

RUN yum install -y nc

EXPOSE 8888

ENV JAVA_OPTS "-Dloader.path=/usr/lib/cdmi-server/plugins/"

CMD /launch_cdmi.sh