FROM italiangrid/base:centos6

ARG CDMI_CLIENT_SECRET
ARG IAM_USER_PASSWORD

# add and run setup
ADD . /
RUN chmod +x /setup.sh
RUN /setup.sh

USER tester

WORKDIR /home/tester

ENV CDMI_CLIENT_SECRET $CDMI_CLIENT_SECRET
ENV IAM_USER_PASSWORD $IAM_USER_PASSWORD

CMD /run_testsuite.sh
