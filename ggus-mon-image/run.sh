#!/bin/bash
set -x

GGUS_REPO=${GGUS_REPO:-https://github.com/andreaceccanti/emi-ggus-mon.git}
GGUS_REPO_BRANCH=${GGUS_REPO_BRANCH:-master}
REPORT_URL=${REPORT_URL:-http://radiohead.cnaf.infn.it:10000/ggus-reports}
REPORT_DIR=${REPORT_DIR:-/reports}

## checkout ggus repo
git clone ${GGUS_REPO} ggus-mon
pushd ggus-mon
git checkout ${GGUS_REPO_BRANCH}
python setup.py install
popd

mkdir -p ${REPORT_DIR}
touch ${REPORT_DIR}/index.html
ls /usr/src/app
ls /usr/src/app/assets
cp -r /usr/src/app/assets/* ${REPORT_DIR}

ggus.py cnaf                  \
  --skip_notification         \
  --target_dir=${REPORT_DIR}  \
  --report_url=${REPORT_URL}

ls /reports
