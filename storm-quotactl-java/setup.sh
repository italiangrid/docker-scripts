#!/bin/bash

# install the list of puppet modules after downloading from github
git clone git://github.com/enricovianello/storm-quotactl-java.git /storm-quotactl-java

# install all puppet modules required by the StoRM testsuite. 
# the "--detailed-exitcodes" flag returns explicit exit status:
# exit code '2' means there were changes
# exit code '4' means there were failures during the transaction
# exit code '6' means there were both changes and failures
puppet apply --modulepath=/ci-puppet-modules/modules:/etc/puppet/modules/ --detailed-exitcodes /manifest.pp

# check if errors occurred after puppet apply:
if [[ ( $? -eq 4 ) || ( $? -eq 6 ) ]]; then
  exit 1
fi

# install quota and xfsprogs
yum install -y quota xfsprogs

# check if errors occurred after fetch-crl execution
if [ $? != 0 ]; then
  exit 1
fi

# enable quota on filesystem
echo "This is the /etc/fstab file content ..."
cat /etc/fstab

echo "Remove fstab file ..."
rm -f /etc/fstab

cat > /etc/fstab << EOF
LABEL=_/   /        ext4      defaults,grpjquota=aquota.group,jqfmt=vfsv0         0 0
devpts     /dev/pts  devpts  gid=5,mode=620   0 0
tmpfs      /dev/shm  tmpfs   defaults         0 0
proc       /proc     proc    defaults         0 0
sysfs      /sys      sysfs   defaults         0 0
EOF

echo "This is the new /etc/fstab file content ..."
cat /etc/fstab

id

whoami

#ls -l /etc/smb_credentials.txt 

#sudo mount -v -o remount /

#quotacheck -avugm

#ls /aquota.group

#quotaon -avug

groupadd test.vo
useradd storm

chmod +x /run_tests.sh

mkdir /storage
mkdir /storage/test.vo
chown -R storm:test.vo /storage/test.vo
chmod 750 /storage/test.vo
