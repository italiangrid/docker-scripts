#!/bin/bash
set -ex
tags=${tags:-"centos5 centos6"}

for t in ${tags}; do
    docker build --pull=false \
      --rm=true --no-cache=true \
      -t italiangrid/storm-deployment-test:${t} -f Dockerfile.${t} .
done
