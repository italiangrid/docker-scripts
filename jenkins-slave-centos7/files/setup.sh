#!/bin/bash
set -ex

JENKINS_UID=${JENKINS_UID:-1234}
DOCKER_GID="${DOCKER_GID:-233}"

yum clean all
yum update -y

## EugridPMA repo
wget --no-clobber -O /etc/yum.repos.d/egi-trustanchors.repo http://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo
rpm --import http://repository.egi.eu/sw/production/cas/1/current/GPG-KEY-EUGridPMA-RPM-3

## Install tools
yum install -y ca-policy-egi-core fetch-crl ca-certificates iptables curl docker-engine-1.10.3-1.el7.centos

## Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

## Change Jenkins UID to be compatible with UID in build images
useradd -m -d /home/jenkins -s /bin/bash -u ${JENKINS_UID} jenkins

## Install cnaf nexus mirror settings
mkdir ~jenkins/.m2
mv /settings.xml ~jenkins/.m2
chown -R jenkins:jenkins ~jenkins ~jenkins/.m2

## Setup jenkins private key
mkdir /home/jenkins/.ssh
cp /authorized_keys /home/jenkins/.ssh
chown -R jenkins:jenkins /home/jenkins/.ssh
chmod 400 /home/jenkins/.ssh/authorized_keys
chmod 700 /home/jenkins/.ssh

## Change docker GID so that it plays nicely with coreos hypervisor
groupmod -g ${DOCKER_GID} docker

## Let jenkins run docker
usermod -a -G docker jenkins

## Install IGI test CA
curl https://raw.githubusercontent.com/andreaceccanti/test-ca/master/igi-test-ca/igi-test-ca.pem -o /etc/pki/tls/certs/igi-test-ca.crt

## Rehash certificates
update-ca-trust
