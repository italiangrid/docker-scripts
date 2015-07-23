#!/bin/bash
set -ex

DEFAULT_REPO=http://radiohead.cnaf.infn.it:9999/job/repo_argus_EL7//lastSuccessfulBuild/artifact/argus_el7.repo
ARGUS_REPO_URL=${ARGUS_REPO_URL:-$DEFAULT_REPO}

wget $ARGUS_REPO_URL -O /etc/yum.repos.d/argus.repo
yum -y update
yum -y install argus-pep-api-c-devel
