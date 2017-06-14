FROM  italiangrid/storm-testsuite

USER root

ADD setup /

RUN chmod +x "/setup.sh"
RUN chmod +x "/run.sh"
RUN chmod +x "/checkproxy.sh"

RUN /setup.sh

WORKDIR /home/tester

RUN cp /run.sh /home/tester/run.sh
RUN cp /checkproxy.sh /home/tester/checkproxy.sh

USER tester

CMD /home/tester/run.sh
