#!/bin/bash
set -ex

# Fetch deployment test script
git clone git://github.com/italiangrid/voms-deployment-test /voms-deployment-test

pushd /voms-deployment-test
sh ${COMPONENT}_${MODE}_${PLATFORM}.sh
popd

echo "Done!"
