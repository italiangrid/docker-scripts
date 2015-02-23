FROM italiangrid/base

ADD . /

RUN chmod +x /setup.sh

# execute setup script
RUN /setup.sh

# expose myproxy server ports
EXPOSE 7512

# setup run script
RUN chmod +x /run.sh

# set an entrypoint for the voms-deployment-test script and keep the container alive
ENTRYPOINT /run.sh && sleep infinity
