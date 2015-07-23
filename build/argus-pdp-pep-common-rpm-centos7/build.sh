#!/bin/sh
set -ex

git clone https://github.com/argus-authz/argus-pdp-pep-common-rpm.git
pushd argus-pdp-pep-common-rpm
git checkout ${ARGUS_PDP_PEP_COMMON_RPM_TAG:-master}
make git_branch=${ARGUS_PDP_PEP_COMMON_TAG:-EMI-3} git_source srpm rpm
