#
# EC4Docker - Elastic Cluster for Docker
# https://github.com/grycap/ec4docker
#
# Copyright (C) GRyCAP - I3M - UPV 
# Developed by Carlos A. caralla@upv.es
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM ubuntu
MAINTAINER Carlos de Alfonso <caralla@upv.es>

# -------------------------------------------------------------------
# This is the part to install the packages
# -------------------------------------------------------------------

# Basic files for NFS and SSH
RUN apt-get update && apt-get install -y openssh-server nfs-common nfs-kernel-server

# -------------------------------------------------------------------
# This is the part to enable SSH access
# -------------------------------------------------------------------

RUN apt-get install sudo
EXPOSE 22
RUN useradd -m -s /bin/bash ubuntu && sudo -u ubuntu ssh-keygen -N "" -f /home/ubuntu/.ssh/id_rsa && sudo -u ubuntu cp /home/ubuntu/.ssh/id_rsa.pub /home/ubuntu/.ssh/authorized_keys
ADD ./commonfiles/config /home/ubuntu/.ssh/
RUN chown ubuntu:ubuntu /home/ubuntu/.ssh/config
RUN echo 'ubuntu:ubuntu' | chpasswd

RUN ssh-keygen -N "" -f /root/.ssh/id_rsa && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# -------------------------------------------------------------------
# This is the part to install EC4Docker
# -------------------------------------------------------------------

# Install the docker binary to be able to run docker from inside the container
RUN apt-get -y install curl && curl -sSL https://get.docker.com/ | sh

ADD ./poweron ./poweroff ./add-node ./remove-node /opt/ec4docker/

# -------------------------------------------------------------------
# This is the part to install the bootstrapper
# -------------------------------------------------------------------

ADD ./start-node /opt/ec4docker/
ADD ./conf.d /opt/ec4docker/conf.d/
ENTRYPOINT [ "/opt/ec4docker/start-node" ]