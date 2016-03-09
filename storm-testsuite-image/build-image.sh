#!/bin/bash

docker pull italiangrid/base:centos6
docker build -t italiangrid/storm-testsuite .
