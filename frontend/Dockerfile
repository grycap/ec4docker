FROM ubuntu
RUN apt-get update && apt-get install -y torque-server torque-client torque-mom torque-pam g++ libtorque2-dev make openssh-server nfs-common nfs-kernel-server
RUN useradd -m -s /bin/bash ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd
#RUN apt-get -y install curl && bash -c 'curl https://get.docker.com/ | sh'
RUN apt-get -y install libnfnetlink0 libsystemd-journal0 libapparmor1
# libxtables10 patch rsync xz-utils
# ADD ./config authorized_keys id_rsa id_rsa.pub /home/ubuntu/.ssh/
# RUN chown -R ubuntu:ubuntu /home/ubuntu
ADD ./poweron-wn ./start-frontend ./add-node ./remove-node /opt/ec4docker/
ENTRYPOINT [ "/opt/ec4docker/start-frontend" ]
