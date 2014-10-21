#!/bin/bash
set -x

MODE="${MODE:-clean}"
PLATFORM="${PLATFORM:-SL6}"

git clone git://github.com/dandreotti/docker-storm-deployment-test.git
cd docker-storm-deployment-test

DEPLOYMENT_SCRIPT="$MODE-deployment_$PLATFORM.sh"

# install host certificate
wget https://raw.githubusercontent.com/dandreotti/docker-scripts/master/test-certificates/docker_storm_cnaf_infn_it.cert.pem -O /etc/grid-security/hostcert.pem
wget https://raw.githubusercontent.com/dandreotti/docker-scripts/master/test-certificates/docker_storm_cnaf_infn_it.key.pem -O /etc/grid-security/hostkey.pem
chmod 400 /etc/grid-security/hostkey.pem
chmod 644 /etc/grid-security/hostcert.pem

# setup StoRM services
service rsyslog start

sh $DEPLOYMENT_SCRIPT

# configure with yaim
/opt/glite/yaim/bin/yaim -c -s /etc/storm/siteinfo/storm.def -n se_storm_backend -n se_storm_frontend -n se_storm_gridftp -n se_storm_gridhttps

# add SAs links
cd /storage/testers.eu-emi.eu/
ln -s ../dteam dteam
ln -s ../noauth noauth_sa

cd /storage/noauth/
ln -s ../testers.eu-emi.eu testers

# stop StoRM services
pkill -f storm-frontend-server

# disable frontend monitor
sed -i -e '/monitoring.enabled=true/c\monitoring.enabled=false' /etc/storm/frontend-server/storm-frontend-server.conf

sh /daemons/frontend
