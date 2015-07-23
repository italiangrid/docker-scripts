#!/bin/bash
set -ex

yum clean all
yum -y update

yum -y install argus-pap

source /etc/sysconfig/argus-pap
source /usr/share/argus/pap/sbin/pap-env.sh

$PAP_CMD
