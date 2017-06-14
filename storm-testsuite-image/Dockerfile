FROM italiangrid/base:centos6

USER root

COPY manifest.pp /manifest.pp
COPY setup.sh /setup.sh
RUN chmod +x /setup.sh
RUN /setup.sh

RUN adduser -d /home/tester tester
COPY run_testsuite.sh /home/tester
RUN chmod +x /home/tester/run_testsuite.sh
RUN chown tester:tester /home/tester/run_testsuite.sh

USER tester

WORKDIR /home/tester

RUN mkdir .globus

CMD ./run_testsuite.sh
