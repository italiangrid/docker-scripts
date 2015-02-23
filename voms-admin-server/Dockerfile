FROM italiangrid/base-dev

ADD setup /
RUN chmod 755 "/run.sh"

ENV VOMS_DB_USERNAME voms
ENV VOMS_DB_PASSWORD pwd
ENV VOMS_DB_NAME voms_test
ENV VOMS_MAIL_FROM voms-admin@dev.local.io

VOLUME /var/log/voms-admin

CMD /run.sh

EXPOSE 8443 1044
