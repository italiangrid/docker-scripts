#!/bin/bash
set -x

git clone git://github.com/dandreotti/storm-deployment-test.git
cd storm-deployment-test
git checkout fix/STOR-654

SETUP_SCRIPT="setup-scripts/SL6/setup-emi3-devel-sl6.sh"

DEPLOYMENT_SCRIPT="clean-deployment_SL6.sh"

# install host certificate
wget https://raw.githubusercontent.com/dandreotti/docker-scripts/master/test-certificates/docker_storm_cnaf_infn_it.cert.pem -O /etc/grid-security/hostcert.pem
wget https://raw.githubusercontent.com/dandreotti/docker-scripts/master/test-certificates/docker_storm_cnaf_infn_it.key.pem -O /etc/grid-security/hostkey.pem
chmod 400 /etc/grid-security/hostkey.pem
chmod 644 /etc/grid-security/hostcert.pem

# setup deployment
source $SETUP_SCRIPT

sed -i -e '/\/opt\/glite\/yaim\/bin\/yaim/i\echo "config_ntp () {"> /opt/glite/yaim/functions/local/config_ntp\necho "return 0">> /opt/glite/yaim/functions/local/config_ntp\necho "}">> /opt/glite/yaim/functions/local/config_ntp' $DEPLOYMENT_SCRIPT

sed -i -e '/yum install -y emi-storm-backend-mp/c\yum install -y --enablerepo=centosplus emi-storm-backend-mp emi-storm-frontend-mp emi-storm-globus-gridftp-mp emi-storm-gridhttps-mp' $DEPLOYMENT_SCRIPT

sh $DEPLOYMENT_SCRIPT

# add SAs links
cd /storage/testers.eu-emi.eu/
ln -s ../dteam dteam
ln -s ../noauth noauth_sa

cd /storage/noauth/
ln -s ../testers.eu-emi.eu testers

# stop StoRM services
service storm-backend-server stop
service storm-frontend-server stop
service storm-gridhttps-server stop
service storm-globus-gridftp stop

# setup StoRM services in runit 

