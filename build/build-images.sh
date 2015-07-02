#!/bin/bash

DOCKER_REGISTRY_HOST=${DOCKER_REGISTRY_HOST:-cloud-vm128.cloud.cnaf.infn.it}
IMAGES="centos7 argus-pap-centos7 argus-pap-rpm-centos7 repo"

for d in $IMAGES; do
  cd $d
  sh build-image.sh
  docker tag -f italiangrid/build-$d ${DOCKER_REGISTRY_HOST}/italiangrid/build-$d
  docker push ${DOCKER_REGISTRY_HOST}/italiangrid/build-$d
  cd ..
done
