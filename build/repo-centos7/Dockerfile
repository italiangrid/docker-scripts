FROM italiangrid/build-centos7

ADD run.sh /home/build/
RUN chmod +x /home/build/run.sh
RUN chown build /home/build/run.sh

user build
RUN mkdir /home/build/repo

workdir /home/build

VOLUME /home/build/repo

CMD /home/build/run.sh
