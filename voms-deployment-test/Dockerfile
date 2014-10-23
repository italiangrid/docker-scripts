FROM	centos6/puppetbase:1.0

MAINTAINER Gianni Dalla Torre <dallatorre@cnaf.infn.it>

# install the list of puppet modules after downloading from github
RUN git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules

# install all puppet modules required by the VOMS testsuite
ADD manifest.pp /
RUN puppet apply --modulepath=/modules:/etc/puppet/modules/ /manifest.pp

# download host certificate and key
RUN wget --no-check-certificate https://www.dropbox.com/s/edl3kflft8cb0od/voms_server.cert.pem?dl=0 -O /etc/grid-security/hostcert.pem
RUN wget --no-check-certificate https://www.dropbox.com/s/rz06giyaj3008hp/voms_server.key.pem?dl=0 -O /etc/grid-security/hostkey.pem

# download the voms-deployment-test script and make it executable
RUN wget --no-check-certificate https://raw.github.com/italiangrid/voms-deployment-test/master/voms-deployment-test.sh -O /voms-deployment-test.sh
RUN chmod +x voms-deployment-test.sh

# update all the packages to the latest release
RUN yum clean all -y

# expose the default ports for the services VOMS and VOMS-admin
EXPOSE 15000
EXPOSE 8443

# set default values for environment variables used by the voms-deployment-test script
ENV REPO http://radiohead.cnaf.infn.it:9999/view/REPOS/job/repo_voms_develop_SL6/lastSuccessfulBuild/artifact/voms-develop_sl6.repo
ENV COMPONENT server
ENV MODE clean
ENV PLATFORM SL6
ENV UPDATE yes 

# set an entrypoint for the voms-deployment-test script and keep the container alive
ENTRYPOINT /voms-deployment-test.sh -r $REPO -c $COMPONENT -m $MODE -p $PLATFORM -u $UPDATE && sleep infinity
