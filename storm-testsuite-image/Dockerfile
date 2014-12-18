FROM italiangrid/base

# add and run setup
ADD . /
RUN chmod +x /setup.sh 
RUN /setup.sh

# setup for the tester user
WORKDIR /home/tester

ENTRYPOINT /setup_testsuite.sh
