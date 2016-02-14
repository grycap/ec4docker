FROM ubuntu
RUN apt-get update && apt-get install -y torque-client torque-mom openssh-server nfs-common
RUN useradd -m -s /bin/bash ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd
ADD start-node /opt/ec4docker/
ADD ./conf.d /opt/ec4docker/conf.d/
ENTRYPOINT [ "/opt/ec4docker/start-node" ]