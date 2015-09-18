#!/bin/bash
set -ex

# install grinder
wget https://www.dropbox.com/s/2s974oqhyttgdjh/grinder-cnaf-3.11-binary.tar.gz
tar -C /opt -xvzf grinder-cnaf-3.11-binary.tar.gz
rm -f grinder-cnaf-3.11-binary.tar.gz

#CERT_DIR=/usr/share/igi-test-ca
#USER=test0
#echo "Copy user certificate and key to globus directory ..."
#cp $CERT_DIR/$USER.cert.pem /home/tester/.globus/usercert.pem
#chmod 644 /home/tester/.globus/usercert.pem
#cp $CERT_DIR/$USER.key.pem /home/tester/.globus/userkey.pem
#chmod 400 /home/tester/.globus/userkey.pem
#chown tester:tester /home/tester/.globus/*.pem
#ls -latr /home/tester/.globus

echo 'export X509_USER_PROXY="/tmp/x509up_u$(id -u)"'>/etc/profile.d/x509_user_proxy.sh
cat /etc/profile.d/x509_user_proxy.sh

echo 'export GRINDER_HOME="/opt/grinder-3.11"'>/etc/profile.d/grinder.sh
cat /etc/profile.d/grinder.sh

