VOMS testsuite image
==============


A docker image based on Centos for testing VOMS clients.


## Build the voms-testsuite image

First build the centos6/puppetbase:1.0 image as explained in puppet-baseimage/README.md.

Then run: 

    docker build --no-cache -t centos6/voms-ts:1.0 .

Changes to added scripts (*setup_clients.sh* and *get_puppet_modules.sh*) require a re-build of the image.

## Running the VOMS testsuite 

Input parameters are the repo of the desired version of VOMS clients to install and the git repo from where cloning the VOMS testsuite.

 **Time on the host where container will run must be synchronized with time on servers used for testing.**

    docker run -v /etc/localtime:/etc/localtime:ro --name voms-ts -e "VOMSREPO=http://radiohead.cnaf.infn.it:9999/view/REPOS/job/repo_voms_develop_SL6/lastSuccessfulBuild/artifact/voms-develop_sl6.repo" centos6/voms-ts:1.0

