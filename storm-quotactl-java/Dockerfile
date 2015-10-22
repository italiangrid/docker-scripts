FROM italiangrid/base-dev

# add and run setup
ADD . /
RUN chmod +x /setup.sh 
RUN /setup.sh

# setup for the tester user
WORKDIR /home/storm

CMD /run_tests.sh
