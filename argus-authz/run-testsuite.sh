#!/bin/bash

REGISTRY=cloud-vm128.cloud.cnaf.infn.it/
TESTSUITE_BRANCH=${TESTSUITE_BRANCH:-master}
DOCKER_NET_NAME=${DOCKER_NET_NAME:-argusauthz_default}
pap_host=argus-pap.cnaf.test
pdp_host=argus-pdp.cnaf.test
pep_host=argus-pep.cnaf.test
pdp_admin_password=pdpadmin_password

docker rm -f argus-testsuite

docker run --net=$DOCKER_NET_NAME \
    --name=argus-testsuite \
    -e T_PDP_ADMIN_PASSWORD=$pdp_admin_passwd \
    -e PAP_HOST=$pap_host \
    -e PDP_HOST=$pdp_host \
    -e PEP_HOST=$pep_host \
    -e TESTSUITE_BRANCH=$TESTSUITE_BRANCH \
    -e TIMEOUT=600 \
    ${REGISTRY}italiangrid/argus-testsuite:latest
