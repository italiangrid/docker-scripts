FROM italiangrid/base

ADD setup /
RUN chmod 755 /setup.sh
RUN /setup.sh

# set default values for environment variables used by the voms-deployment-test script
ENV VOMS_REPO http://radiohead.cnaf.infn.it:9999/view/REPOS/job/repo_voms_develop_SL6/lastSuccessfulBuild/artifact/voms-develop_sl6.repo
ENV COMPONENT server
ENV MODE clean
ENV PLATFORM EL6
ENV SYNC_FILE /sync/start-ts

# set an entrypoint for the voms-deployment-test script and keep the container alive
ENTRYPOINT /run.sh && touch $SYNC_FILE && sleep infinity
