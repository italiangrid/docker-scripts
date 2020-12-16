#!/bin/bash
set -ex

tags=${tags:-"centos7"}

for t in ${tags}; do
  echo "Pushing italiangrid/storm-build:${t} on dockerhub ..."
  docker push italiangrid/storm-build:${t}
done
