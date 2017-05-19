#!/bin/bash
set -ex

if [ -n "${DOCKER_REGISTRY_HOST}" ]; then
  docker tag -f  italiangrid/cdmi-storm ${DOCKER_REGISTRY_HOST}/italiangrid/cdmi-storm
  docker push ${DOCKER_REGISTRY_HOST}/italiangrid/cdmi-storm
fi

if [ -n "${PUSH_TO_DOCKERHUB}" ]; then
  docker push italiangrid/cdmi-storm
fi
