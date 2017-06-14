#!/bin/bash

docker build --build-arg CDMI_CLIENT_SECRET=${CDMI_CLIENT_SECRET} --build-arg IAM_USER_PASSWORD=${IAM_USER_PASSWORD} -t italiangrid/storm-testsuite .
