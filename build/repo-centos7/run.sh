#!/bin/bash
set -ex

PACKAGES_DIR=${PACKAGES_DIR:-/packages}

ls -lR ${PACKAGES_DIR}
pushd ${PACKAGES_DIR}

createrepo -v RPMS
createrepo -v SRPMS
