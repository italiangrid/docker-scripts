FROM italiangrid/base:centos6

ARG CDMI_CLIENT_SECRET
ARG IAM_USER_PASSWORD

USER root

COPY setup.sh /setup.sh
RUN chmod +x /setup.sh
RUN /setup.sh

RUN adduser -d /home/tester tester
USER tester
WORKDIR /home/tester
RUN mkdir .globus

ENV CDMI_CLIENT_SECRET $CDMI_CLIENT_SECRET
ENV IAM_USER_PASSWORD $IAM_USER_PASSWORD

COPY run_testsuite.sh /home/tester
RUN chmod +x run_testsuite.sh

CMD ./run_testsuite.sh
