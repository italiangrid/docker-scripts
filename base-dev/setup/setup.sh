#!/bin/bash
set -ex

yum -y upgrade ca-certificates --disablerepo=epel

## Setup host certificate
mkdir -p /etc/grid-security
cp /dev_local_io.cert.pem /etc/grid-security/hostcert.pem
cp /dev_local_io.key.pem /etc/grid-security/hostkey.pem
chmod 400 /etc/grid-security/hostkey.pem

## Run puppet
git clone git://github.com/cnaf/ci-puppet-modules.git /ci-puppet-modules
puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ /manifest.pp

## Install minimal utils
yum -y install nc mysql $JAVA_PACKAGE
java -version

## Clean things up
yum clean all
