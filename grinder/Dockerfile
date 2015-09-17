FROM  italiangrid/storm-testsuite

ADD setup /

RUN chmod +x "/setup.sh"
RUN chmod +x "/run.sh"

RUN /setup.sh

WORKDIR /home/tester

RUN cp /run.sh /home/tester/run.sh

USER tester

CMD /home/tester/run.sh
