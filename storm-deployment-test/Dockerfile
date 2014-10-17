FROM centos6/baseimage:1.0

#install the list of puppet modules after downloading from github
add get_puppet_modules.sh /
run ./get_puppet_modules.sh

#apply all puppet modules required
add manifest.pp /
run puppet apply  manifest.pp

run yum install -y attr
run yum install -y acl

# expose StoRM ports
expose 8080
expose 8085
expose 8086 
expose 8443
expose 8444
expose 9998

# install clients setup script
add deploy.sh /
run chmod +x /deploy.sh
#entrypoint /deploy.sh
CMD ["/sbin/my_init"]
