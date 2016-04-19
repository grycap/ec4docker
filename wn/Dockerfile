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

RUN apt-get update && apt-get install -y openssh-server nfs-common

# -------------------------------------------------------------------
# This is the part to enable SSH access
# -------------------------------------------------------------------

RUN useradd -m -s /bin/bash ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd

# -------------------------------------------------------------------
# This is the part to install the bootstrapper
# -------------------------------------------------------------------

ADD ./start-node /opt/ec4docker/
ADD ./conf.d /opt/ec4docker/conf.d/
ENTRYPOINT [ "/opt/ec4docker/start-node" ]