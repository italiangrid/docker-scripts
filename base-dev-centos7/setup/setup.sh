#!/bin/bash
set -ex

## Setup host certificate
mkdir -p /etc/grid-security
cp /dev_local_io.cert.pem /etc/grid-security/hostcert.pem
cp /dev_local_io.key.pem /etc/grid-security/hostkey.pem
chmod 400 /etc/grid-security/hostkey.pem

## Install minimal utils
yum -y install nc
java -version

## Clean things up
yum clean all
