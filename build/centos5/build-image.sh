#!/bin/bash

docker build --rm -t italiangrid/build-centos5 .
docker tag italiangrid/build-centos5 italiangrid/build:centos5
