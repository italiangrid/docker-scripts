#!/bin/bash

# docker build --rm -t andreaceccanti/vim-dev-base -f Dockerfile-base .
docker build -f Dockerfile --rm -t andreaceccanti/vim-dev .
