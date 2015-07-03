#!/bin/sh
set -ex

git clone https://github.com/argus-authz/argus-pep-cli-rpm.git
pushd argus-pep-cli-rpm
git checkout ${ARGUS_PEP_CLI_RPM:-master}
make git_branch=${ARGUS_PEP_CLI:-EMI-3} git_source srpm rpm
