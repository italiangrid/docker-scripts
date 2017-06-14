#!/bin/bash
set -ex

docker build --pull=false --rm=true -t italiangrid/cdmi-storm .
