#!/bin/sh

set -xe

DOCKER_REGISTRY_HOST=${DOCKER_REGISTRY_HOST:-"cloud-vm128.cloud.cnaf.infn.it"}

image_name=italiangrid/selenium-node-firefox
dest=${DOCKER_REGISTRY_HOST}/$image_name:latest
	
docker tag $image_name $dest
docker push $dest