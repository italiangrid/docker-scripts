#!/bin/bash
set -ex

docker build --pull=false --rm=true --build-arg CLIENT_ID=${CLIENT_ID} --build-arg CLIENT_SECRET=${CLIENT_SECRET} -t italiangrid/cdmi-storm .
