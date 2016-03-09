#!/bin/bash

if [ -n "${DOCKER_REGISTRY_HOST}" ]; then
  docker pull ${DOCKER_REGISTRY_HOST}/italiangrid/base:centos6
fi

docker build -t italiangrid/storm-testsuite .
