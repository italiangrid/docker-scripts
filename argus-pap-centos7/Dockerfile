FROM  italiangrid/base-dev-centos7

ADD setup.sh run.sh /
RUN chmod 755 /setup.sh /run.sh
RUN /setup.sh
EXPOSE 8150
CMD /run.sh
VOLUME /var/log/argus/pap
VOLUME /var/lib/argus/pap/repository
