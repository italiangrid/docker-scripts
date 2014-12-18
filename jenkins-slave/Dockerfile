FROM evarga/jenkins-slave

ENV DEBIAN_FRONTEND noninteractive

ADD setup.sh /setup.sh
ADD authorized_keys /authorized_keys
RUN chmod +x /setup.sh
RUN /setup.sh
