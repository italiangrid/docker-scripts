#!/bin/bash

if [ $ENABLE_CHECKPROXY ];
then

  voname=$TESTSUITE_VONAME

  openssl x509 -checkend 120 -noout -in $X509_USER_PROXY
  ok=$?

  if [ $ok -eq 0 ]; then
    echo "Certificate is not yet expired!"
  else
    echo "Certificate has expired or will do so within 30 minutes!"
    echo "(or is invalid/not found)"
    cd
    echo pass|voms-proxy-init -pwstdin --voms $voname
  fi
fi
