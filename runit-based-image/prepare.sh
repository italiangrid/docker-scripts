#!/bin/bash
set -e
source /build/buildconfig
set -x

# update packages
yum -y update 

## Workaround https://github.com/dotcloud/docker/issues/2267,
## not being able to modify /etc/hosts.
mkdir -p /etc/workaround-docker-2267
ln -s /etc/workaround-docker-2267 /cte
cp /build/bin/workaround-docker-2267 /usr/bin/

