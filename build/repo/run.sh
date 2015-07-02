#!/bin/bash
set -ex

mkdir -p repo/yum
mkdir -p repo/src

find /packages/RPMS -name '*.rpm' -exec cp '{}' repo/yum \;
find /packages/SRPMS -name '*.rpm' -exec cp '{}' repo/src \;

pushd repo
createrepo -v yum
createrepo -v src
