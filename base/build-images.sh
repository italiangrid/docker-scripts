#!/bin/bash
set -ex
tags=${tags:-"centos6"}

for t in ${tags}; do
    docker build --pull=true \
      --rm=true --no-cache=true \
      -t italiangrid/base:${t} -f Dockerfile.${t} .
done
