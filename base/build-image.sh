#!/bin/bash

docker build --force-rm=true --no-cache -t italiangrid:base .
docker login --password=${REGISTRY_PASSWORD} --username="jenkins" --email=" " https://cloud-vm128.cloud.cnaf.infn.it
docker tag italiangrid:base cloud-vm128.cloud.cnaf.infn.it/italiangrid:base
docker push cloud-vm128.cloud.cnaf.infn.it/italiangrid:base
