#!/bin/bash

docker build --rm -t italiangrid/build-centos6 .
docker tag italiangrid/build-centos6 italiangrid/build:centos6
