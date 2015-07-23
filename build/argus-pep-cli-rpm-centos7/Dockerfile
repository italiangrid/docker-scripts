FROM  italiangrid/build-centos7

RUN yum -y install autoconf automake libtool libcurl-devel
ADD setup.sh /setup.sh
RUN sh /setup.sh

user build
workdir /home/build

add build.sh /home/build/

CMD sh build.sh
