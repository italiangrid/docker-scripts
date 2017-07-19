#!/bin/bash
set -ex

if [ -n "${DOCKER_REGISTRY_HOST}" ]; then
  docker tag italiangrid/cdmi-storm ${DOCKER_REGISTRY_HOST}/italiangrid/cdmi-storm
  docker push ${DOCKER_REGISTRY_HOST}/italiangrid/cdmi-storm
fi