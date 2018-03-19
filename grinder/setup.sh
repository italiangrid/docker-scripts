#!/bin/bash
set -ex

# install grinder
wget https://www.dropbox.com/s/2s974oqhyttgdjh/grinder-cnaf-3.11-binary.tar.gz
tar -C /opt -xvzf grinder-cnaf-3.11-binary.tar.gz
rm -f grinder-cnaf-3.11-binary.tar.gz

echo 'export X509_USER_PROXY="/tmp/x509up_u$(id -u)"'>/etc/profile.d/x509_user_proxy.sh
cat /etc/profile.d/x509_user_proxy.sh

echo 'export GRINDER_HOME="/opt/grinder-3.11"'>/etc/profile.d/grinder.sh
cat /etc/profile.d/grinder.sh

mkdir -p /etc/storm/grinder
chmod -R 777 /etc/storm

# Ptp_Pd test need this
echo "test file" > /tmp/prova.txt
chmod 777 /tmp/prova.txt
