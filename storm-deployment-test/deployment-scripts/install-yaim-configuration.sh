#!/bin/bash
set -ex
trap "exit 1" TERM

[ -e "/etc/storm/siteinfo" ] || mkdir -p /etc/storm/siteinfo/vo.d

# Copy siteinfo configuration to /etc/storm/siteinfo
cp -r ./siteinfo/* /etc/storm/siteinfo
