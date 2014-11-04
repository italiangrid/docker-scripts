FROM centos6/puppetbase:1.0

ADD setup /
RUN chmod 755 /setup.sh && /setup.sh

# set default values for environment variables used by the voms-deployment-test script
ENV REPO http://radiohead.cnaf.infn.it:9999/view/REPOS/job/repo_voms_develop_SL6/lastSuccessfulBuild/artifact/voms-develop_sl6.repo
ENV COMPONENT server
ENV MODE clean
ENV PLATFORM SL6
ENV UPDATE yes
ENV SYNC_FILE /sync/start-ts

# expose the default ports for the services VOMS and VOMS-admin
EXPOSE 15000 8443

# set an entrypoint for the voms-deployment-test script and keep the container alive
ENTRYPOINT /voms-deployment-test.sh -r $REPO -c $COMPONENT -m $MODE -p $PLATFORM -u $UPDATE && touch $SYNC_FILE && sleep infinity
