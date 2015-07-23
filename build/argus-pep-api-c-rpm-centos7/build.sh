#!/bin/sh
set -ex

git clone https://github.com/argus-authz/argus-pep-api-c-rpm.git
pushd argus-pep-api-c-rpm
git checkout ${ARGUS_PEP_API_C_RPM:-master}
make git_branch=${ARGUS_PEP_API_C_TAG:-EMI-3} git_source srpm rpm
