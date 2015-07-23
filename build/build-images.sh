#!/bin/bash

DOCKER_REGISTRY_HOST=${DOCKER_REGISTRY_HOST:-cloud-vm128.cloud.cnaf.infn.it}
IMAGES="centos7 argus-pap-centos7 argus-pap-rpm-centos7 \
  repo argus-pdp-pep-common-rpm-centos7 argus-pdp-rpm-centos7 argus-pep-api-c-rpm-centos7 \
  argus-pep-cli-rpm-centos7 argus-pep-common-rpm-centos7 argus-pep-server-rpm-centos7"

for d in $IMAGES; do
  cd $d
  sh build-image.sh
  docker tag -f italiangrid/build-$d ${DOCKER_REGISTRY_HOST}/italiangrid/build-$d
  docker push ${DOCKER_REGISTRY_HOST}/italiangrid/build-$d
  cd ..
done
