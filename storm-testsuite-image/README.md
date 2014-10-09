STORM testsuite image
==============


## Build the storm-testsuite image

First build the centos6/puppetbase:1.0 image as explained in puppet-baseimage/README.md.

Then run: 

    docker build --no-cache -t centos6/storm-ts:1.0 .

Changes to added scripts (*setup_clients.sh* and *get_puppet_modules.sh*) require a re-build of the image.

## Running the STORM testsuite 

Input parameters are the repo of the desired version of VOMS clients to install and STORM backend server.

 **Time on the host where container will run must be synchronized with time on servers used for testing.**

    docker run -e "VOMSREPO=http://radiohead.cnaf.infn.it:9999/view/REPOS/job/repo_voms_develop_SL6/lastSuccessfulBuild/artifact/voms-develop_sl6.repo" -e "STORM_BE_HOST=omii005-vm03.cnaf.infn.it" -v /etc/localtime:/etc/localtime:ro --name storm-ts centos6/storm-ts:1.0

