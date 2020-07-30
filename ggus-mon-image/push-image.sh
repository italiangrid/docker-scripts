#!/bin/bash

set -xe

TAG=${TAG:-"latest"}

docker push italiangrid/ggus-mon:$TAG
