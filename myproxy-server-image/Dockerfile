FROM italiangrid/base

ADD . /

# execute setup script
RUN chmod +x /setup.sh && /setup.sh

# expose myproxy server ports
EXPOSE 7512

# setup run script
RUN chmod +x /run.sh

# set an entrypoint for the voms-deployment-test script and keep the container alive
ENTRYPOINT /run.sh && sleep infinity
