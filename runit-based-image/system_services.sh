#!/bin/bash
set -e
source /build/buildconfig
set -x

## Install init process.
cp /build/bin/my_init /sbin/
mkdir -p /etc/my_init.d
mkdir -p /etc/container_environment
touch /etc/container_environment.sh
touch /etc/container_environment.json
chmod 700 /etc/container_environment

groupadd -g 8377 docker_env
chown :docker_env /etc/container_environment.sh /etc/container_environment.json
chmod 640 /etc/container_environment.sh /etc/container_environment.json
ln -s /etc/container_environment.sh /etc/profile.d/

## Install runit.
yum  -y install rpmdevtools git glibc-static
yum  -y groupinstall "Development Tools"
git clone https://github.com/imeyer/runit-rpm runit-rpm
cd ./runit-rpm
./build.sh
yum install -y /root/rpmbuild/RPMS/x86_64/runit-2.1.2-1.el6.x86_64.rpm

## Install a syslog daemon.
$minimal_yum_install rsyslog
mkdir /etc/service/rsyslog
cp /build/runit/rsyslog /etc/service/rsyslog/run
mkdir -p /var/lib/rsyslog
cp /build/config/rsyslog_default /etc/default/rsyslog

# Replace the system() source because inside Docker we
# can't access /proc/kmsg.
sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/rsyslog.conf

## Install logrotate.
$minimal_yum_install logrotate

## Install cron daemon.
$minimal_yum_install cronie
mkdir -p /etc/service/crond
cp /build/runit/cron /etc/service/crond/run

## Remove useless cron entries.
# Checks for lost+found and scans for mtab.
rm -f /etc/cron.daily/standard
