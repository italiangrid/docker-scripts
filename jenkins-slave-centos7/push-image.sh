#!/bin/bash
set -ex

IMAGE_NAME="italiangrid/jenkins-slave-centos7"

if [ -n "${DOCKER_REGISTRY_HOST}" ]; then
    docker tag -f  ${IMAGE_NAME} ${DOCKER_REGISTRY_HOST}/${IMAGE_NAME}
    docker push ${IMAGE_NAME}
else
    echo "Please define the DOCKER_REGISTRY_HOST env variable"
    exit 1
fi
