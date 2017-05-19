FROM centos:7

RUN yum update -y
RUN yum install -y wget git
#java-1.8.0-openjdk-devel

RUN wget https://ci.cloud.cnaf.infn.it/view/storm/job/CDMI/lastSuccessfulBuild/artifact/cdmi-server-1.2-1.fc25.x86_64.rpm
RUN yum localinstall -y cdmi-server-1.2-1.fc25.x86_64.rpm

WORKDIR /etc/yum.repos.d
#RUN wget http://repo.indigo-datacloud.eu/repos/2/indigo2.repo
#RUN rpm --import http://repo.indigo-datacloud.eu/repository/RPM-GPG-KEY-indigodc
#RUN yum install -y cdmi-server

RUN wget http://radiohead.cnaf.infn.it:9999/job/pkg.storm-fixSTOR929-centos6/lastSuccessfulBuild/artifact/storm.repo -O cdmi-storm.repo
RUN yum clean all
RUN yum install -y cdmi-storm

COPY launch_cdmi.sh /launch_cdmi.sh
RUN chmod +x /launch_cdmi.sh

COPY ./etc/cdmi-server/plugins/* /etc/cdmi-server/plugins/
WORKDIR /var/lib/cdmi-server/config
RUN mv application.yml application.yml.original
COPY ./var/lib/cdmi-server/config/application.yml .

RUN yum install -y nc

EXPOSE 8888

USER cdmi

#WORKDIR /var/lib/cdmi-server
ENV JAVA_OPTS "-Dloader.path=/usr/lib/cdmi-server/plugins/"

CMD /launch_cdmi.sh
#CMD ./cdmi-server-1.2.jar