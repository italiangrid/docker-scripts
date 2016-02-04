FROM centos:7

RUN yum -y update
RUN yum -y groupinstall "Development Tools"
RUN yum -y install gcc gcc-c++ kernel-devel zlib zlib-devel ruby-devel ruby nodejs

RUN gem install github-pages

VOLUME /site

EXPOSE 4000

WORKDIR /site
ENTRYPOINT ["jekyll"]
