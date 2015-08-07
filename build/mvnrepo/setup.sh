#!/bin/sh

BUILD_USER=${BUILD_USER:-build}
BUILD_USER_UID=${BUILD_USER_UID:-1234}

adduser -u ${BUILD_USER_UID} ${BUILD_USER}
mkdir /m2-repository

chown -R ${BUILD_USER}:${BUILD_USER} /m2-repository
