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

# run fetch-crl
fetch-crl

# check if errors occurred after fetch-crl execution
if [ $? != 0 ]; then
  exit 1
fi

# enable quota on filesystem
cat /etc/fstab

line = `grep -n swap /etc/fstab | cut -d : -f 1`
replaced_line = "/dev/mapper/vg_vol01-lv_root / ext4 defaults,grpjquota=aquota.group,jqfmt=vfsv0 1 1"
sed -i '$lines/.*/$replaced_line/' /etc/fstab

mount -o remount /

quotacheck -avugm

ls /aquota.group

quotaon -avug

groupadd test.vo

chmod +x /run_tests.sh

mkdir /storage
mkdir /storage/test.vo
chown -R storm:test.vo /storage/test.vo
chmod 750 /storage/test,vo