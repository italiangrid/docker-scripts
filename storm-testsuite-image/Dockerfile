FROM italiangrid/base

# add and run setup
ADD . /
RUN chmod +x /setup.sh 
RUN /setup.sh

# setup for the tester user
WORKDIR /home/tester

CMD /setup_testsuite.sh
