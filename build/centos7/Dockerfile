FROM  centos:7

ADD apache-maven.repo gpfs.repo /etc/yum.repos.d/
ADD setup.sh settings.xml /
RUN chmod +x /setup.sh
RUN /setup.sh

VOLUME /m2-repository
