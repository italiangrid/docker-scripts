FROM  italiangrid/storm-testsuite

USER root

COPY setup.sh .
COPY run.sh .
COPY checkproxy.sh .
COPY testsuite.properties.template .

RUN chmod +x setup.sh
RUN chmod +x run.sh
RUN chmod +x checkproxy.sh

RUN ./setup.sh

WORKDIR /home/tester

USER tester

CMD /home/tester/run.sh
