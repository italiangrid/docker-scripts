#!/bin/bash
set -ex
tags=${tags:-"centos6"}

for t in ${tags}; do
    docker build --pull=false \
      --rm=true --no-cache=true \
      -t italiangrid/storm-build:${t} -f Dockerfile.${t} .
done
