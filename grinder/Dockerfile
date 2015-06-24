FROM  italiangrid/storm-testsuite

ADD setup /

RUN chmod +x /setup.sh
RUN /setup.sh

# setup for the tester user
WORKDIR /home/tester

ENTRYPOINT /setup_testsuite.sh
