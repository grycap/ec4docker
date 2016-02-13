FROM ubuntu
RUN apt-get update && apt-get install -y torque-server torque-client torque-mom torque-pam g++ libtorque2-dev make openssh-server nfs-common nfs-kernel-server
RUN useradd -m -s /bin/bash ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd
RUN apt-get -y install libnfnetlink0 libsystemd-journal0 libapparmor1
ADD ./poweron ./poweroff ./start-frontend ./add-node ./remove-node /opt/ec4docker/
ADD ./conf.d /opt/ec4docker/conf.d/
ENTRYPOINT [ "/opt/ec4docker/start-frontend" ]
