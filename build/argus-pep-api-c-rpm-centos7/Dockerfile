FROM  italiangrid/build-centos7

RUN yum -y install autoconf automake libtool libcurl-devel

user build
workdir /home/build

add build.sh /home/build/

CMD sh build.sh
