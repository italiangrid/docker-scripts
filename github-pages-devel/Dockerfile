FROM italiangrid/base-dev-centos7

RUN yum -y update
RUN yum -y groupinstall "Development Tools"
RUN yum -y install wget gcc gcc-c++ g++ kernel-devel zlib zlib-devel nodejs make automake autoconf curl-devel openssl-devel httpd-devel apr-devel apr-util-devel sqlite-devel ruby rubygems ruby-rdoc ruby-devel

RUN gem install github-pages
RUN gem update github-pages

VOLUME /site

EXPOSE 4000

WORKDIR /site
ENTRYPOINT ["jekyll"]
