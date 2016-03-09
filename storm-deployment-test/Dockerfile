FROM italiangrid/base:centos6

ADD . /

run chmod +x /setup.sh
run /setup.sh

# expose StoRM ports
expose 8080 8085 8086 8443 8444 9998

# setup deployment script
run chmod +x /deploy.sh

# setup StoRM daemons
run chmod -R +x /daemons
