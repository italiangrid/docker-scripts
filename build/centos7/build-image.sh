#!/bin/bash

docker build --rm -t italiangrid/build-centos7 .
docker tag italiangrid/build-centos7 italiangrid/build:centos7
