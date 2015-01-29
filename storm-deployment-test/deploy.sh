#!/bin/bash
set -x

MODE="${MODE:-clean}"
PLATFORM="${PLATFORM:-SL6}"
STORM_REPO=${STORM_REPO:-http://radiohead.cnaf.infn.it:9999/view/REPOS/job/repo_storm_develop_SL6/lastSuccessfulBuild/artifact/storm_develop_sl6.repo}

DEPLOYMENT_SCRIPT="$MODE-deployment_$PLATFORM.sh"

# install host certificate
cp /storm-certificates/docker_storm_cnaf_infn_it.cert.pem /etc/grid-security/hostcert.pem
cp /storm-certificates/docker_storm_cnaf_infn_it.key.pem /etc/grid-security/hostkey.pem
chmod 400 /etc/grid-security/hostkey.pem
chmod 644 /etc/grid-security/hostcert.pem

# setup StoRM services
service rsyslog start

cd /deployment-scripts

wget https://raw.githubusercontent.com/italiangrid/storm-deployment-test/master/siteinfo/storm.def -O ./siteinfo/storm.def

chmod +x $DEPLOYMENT_SCRIPT
STORM_REPO=$STORM_REPO ./$DEPLOYMENT_SCRIPT

# add SAs links
cd /storage/testers.eu-emi.eu/
ln -s ../dteam dteam
ln -s ../noauth noauth_sa

cd /storage/noauth/
ln -s ../testers.eu-emi.eu testers

# disable frontend monitor
sed -i -e '/monitoring.enabled=true/c\monitoring.enabled=false' /etc/storm/frontend-server/storm-frontend-server.conf

sh /daemons/frontend
