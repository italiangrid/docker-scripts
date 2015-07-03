#!/bin/sh
set -ex

git clone https://github.com/argus-authz/argus-pep-server-rpm.git
pushd argus-pep-server-rpm
git checkout ${ARGUS_PEP_SERVER_RPM_TAG:-master}
make git_branch=${ARGUS_PEP_SERVER_TAG:-EMI-3} git_source srpm rpm
