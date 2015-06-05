#!/bin/sh
set -ex

git clone https://github.com/argus-authz/argus-pap.git
pushd argus-pap
mvn -U package
