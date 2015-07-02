#!/bin/sh
set -ex

git clone https://github.com/argus-authz/argus-pap-rpm.git
pushd argus-pap-rpm
git checkout ${ARGUS_PAP_RPM_TAG:-EL7}
make tag=${ARGUS_PAP_TAG:-1_6}
