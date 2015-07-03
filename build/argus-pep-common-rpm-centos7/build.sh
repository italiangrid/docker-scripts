#!/bin/sh
set -ex

git clone https://github.com/argus-authz/argus-pep-common-rpm.git
pushd argus-pep-common-rpm
git checkout ${ARGUS_PEP_COMMON_RPM_TAG:-master}
make git_branch=${ARGUS_PEP_COMMON_TAG:-EMI-3} git_source srpm rpm
