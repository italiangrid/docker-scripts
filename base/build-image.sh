#!/bin/bash

docker build --force-rm=true --no-cache -t italiangrid:base .
docker tag -f italiangrid:base cloud-vm128.cloud.cnaf.infn.it/italiangrid:base
docker push cloud-vm128.cloud.cnaf.infn.it/italiangrid:base
