#!/bin/sh
set -ex

git clone https://github.com/argus-authz/argus-pdp-rpm.git
pushd argus-pdp-rpm
git checkout ${ARGUS_PDP_RPM_TAG:-master}
make git_branch=${ARGUS_PDP_TAG:-EMI-3} git_source srpm rpm
