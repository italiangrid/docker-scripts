#!/bin/sh
set -ex

BUILD_USER=${BUILD_USER:-build}
BUILD_USER_UID=${BUILD_USER_UID:-1234}
BUILD_USER_HOME=${BUILD_USER_HOME:-/home/${BUILD_USER}}

# Use only GARR and CERN mirrors
echo "include_only=.garr.it,.cern.ch" >> /etc/yum/pluginconf.d/fastestmirror.conf

yum clean all
yum install -y hostname epel-release
yum -y update
yum -y install make createrepo \
  which wget rpm-build git tar apache-maven java-1.8.0-openjdk-devel \
  redhat-rpm-config buildsys-macros \
  autoconf automake cmake gcc-c++ libtool sudo

java -version
javac -version
mvn --version

update-alternatives --set java $(realpath /usr/lib/jvm/java-1.8.0-openjdk/jre/bin/java)
update-alternatives --set javac $(realpath /usr/lib/jvm/java-1.8.0-openjdk/bin/javac)

# Add build user to the sudoers
echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
adduser --uid ${BUILD_USER_UID} ${BUILD_USER}
usermod -a -G wheel ${BUILD_USER}

mkdir ${BUILD_USER_HOME}/.m2
cp /settings.xml ${BUILD_USER_HOME}/.m2
mkdir /m2-repository

chown -R ${BUILD_USER}:${BUILD_USER} ${BUILD_USER_HOME} /m2-repository
yum clean all
