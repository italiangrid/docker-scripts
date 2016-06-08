FROM centos:7

## Layer: base
RUN yum update -y &&\
	yum install -y iproute wget curl git

## Layer: Java
RUN yum install -y java-1.8.0-openjdk-devel maven

## Layer: Jenkins
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

COPY files/setup.sh /setup.sh
COPY files/authorized_keys /authorized_keys
COPY files/docker.repo /etc/yum.repos.d/docker.repo

RUN chmod +x /setup.sh
RUN /setup.sh

## Layer: sshd
RUN yum install -y openssh-server && \
	sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd

RUN /usr/sbin/sshd-keygen

EXPOSE 22

CMD ["/usr/sbin/sshd", "-e", "-D"]
