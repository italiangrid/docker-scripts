#!/bin/sh
set -ex

yum clean all
yum install -y hostname epel-release
yum -y update
yum -y install which make createrepo wget rpm-build git tar java-1.8.0-openjdk-devel apache-maven

# Setup JAVA 8 as default for maven
echo 'JAVA_HOME=$JVM_ROOT/java-1.8.0' >> /etc/java/java.conf
echo 2 | alternatives --config java
echo 2 | alternatives --config javac
echo

java -version
javac -version
mvn --version

adduser build
mkdir /home/build/.m2
cp /settings.xml /home/build/.m2
mkdir /m2-repository

chown -R build:build /home/build /m2-repository
yum clean all
