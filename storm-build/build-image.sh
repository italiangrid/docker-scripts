#!/bin/bash
set -ex
tags=${tags:-"centos7"}

for t in ${tags}; do
    docker build -t italiangrid/storm-build:${t} -f Dockerfile.${t} .
done
