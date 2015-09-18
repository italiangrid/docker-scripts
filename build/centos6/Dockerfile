FROM    centos:centos6

ADD setup.sh /
RUN chmod +x /setup.sh
ADD settings.xml /
ADD apache-maven.repo gpfs.repo oracle.repo /etc/yum.repos.d/

RUN /setup.sh

VOLUME /m2-repository
