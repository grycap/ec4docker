FROM ubuntu
RUN apt-get update && apt-get install -y torque-client torque-mom openssh-server nfs-common
RUN useradd -m -s /bin/bash ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd
ADD start-wn /opt/ec4docker/
# ADD config authorized_keys id_rsa id_rsa.pub /home/ubuntu/.ssh/
# RUN chown -R ubuntu:ubuntu /home/ubuntu
ENTRYPOINT [ "/opt/ec4docker/start-wn" ]
