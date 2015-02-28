FROM italiangrid/base-dev

ADD setup /
RUN chmod 755 "/run.sh"

VOLUME /storage

CMD /run.sh

EXPOSE 8080 8444 8555 1044
