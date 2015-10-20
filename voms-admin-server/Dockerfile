FROM italiangrid/base-dev

ADD setup /
RUN chmod 755 "/run.sh"
RUN cp /emi-oracle-11.repo  /etc/yum.repos.d && \
  yum -y install oracle-instantclient-basic \
  java-1.6.0-openjdk-devel \
  java-1.8.0-openjdk-devel \
  voms-admin-server \
  voms-admin-client

ENV VOMS_DB_USERNAME voms
ENV VOMS_DB_PASSWORD pwd
ENV VOMS_DB_NAME voms_test
ENV VOMS_MAIL_FROM voms-admin@dev.local.io

VOLUME /var/log/voms-admin

CMD /run.sh

EXPOSE 8443 1044
