FROM  centos:7

add setup.sh settings.xml /
run chmod +x /setup.sh
run /setup.sh
ADD gpfs.repo /etc/yum.repos.d/

VOLUME /m2-repository
