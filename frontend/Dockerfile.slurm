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

# Packages to install slurm
RUN apt-get update && apt-get install -y libmunge2 libpq5 openssl-blacklist munge libmunge-dev gcc make

# -------------------------------------------------------------------
# This is the part to enable SSH access
# -------------------------------------------------------------------

EXPOSE 22
RUN useradd -m -s /bin/bash ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd

# -------------------------------------------------------------------
# This is the part to install EC4Docker
# -------------------------------------------------------------------

# Packages to be able to run docker from inside the container
RUN apt-get -y install libnfnetlink0 libsystemd-journal0 libapparmor1

ADD ./poweron ./poweroff ./add-node ./remove-node /opt/ec4docker/

# -------------------------------------------------------------------
# This is the part to install the bootstrapper
# -------------------------------------------------------------------

ADD ./start-node /opt/ec4docker/
ADD ./conf.d /opt/ec4docker/conf.d/
ENTRYPOINT [ "/opt/ec4docker/start-node" ]

#
# Compile SLURM
#

RUN wget http://www.schedmd.com/download/archive/slurm-14.11.3.tar.bz2 -O /tmp/slurm.tar.bz2 && cd /tmp && tar xjf slurm.tar.bz2 && cd /tmp/slurm-14.11.3 && ./configure --with-blcr=/usr/local/bin && make && make install
RUN useradd -m -s /bin/bash slurm
RUN echo 'slurm:slurm' | chpasswd
RUN mkdir -p /var/spool/slurm /var/log/slurm /var/slurm/checkpoint && chown slurm:slurm /var/spool/slurm /var/log/slurm /var/slurm/checkpoint

# Include the configuration and bootstrapping for slurm
ADD ./slurmfiles/slurm.conf /usr/local/etc/
ADD ./slurmfiles/04Munge ./slurmfiles/05Slurm /opt/ec4docker/conf.d/
ADD ./slurmfiles/add-node ./slurmfiles/remove-node /opt/ec4docker/

# -------------------------------------------------------------------
# This is the part to install CLUES
# -------------------------------------------------------------------

# Firt we install the dependencies
RUN apt-get install -y python python-setuptools unzip vim && easy_install ply==3.6 web.py

# Now we need the cpyutils
# RUN cd /opt/ && wget https://github.com/grycap/cpyutils/archive/master.zip -O cpyutils.zip && unzip cpyutils.zip && cd cpyutils-master && python setup.py install --record installed-files.txt
RUN cd /opt/ && wget https://github.com/grycap/cpyutils/archive/enhanced-features.zip -O cpyutils.zip && unzip cpyutils.zip && cd cpyutils-enhanced-features && python setup.py install --record installed-files.txt

# Finally we install CLUES
# RUN cd /opt/ && wget https://github.com/grycap/clues/archive/master.zip -O clues.zip && unzip clues.zip && cd clues-master && python setup.py install --record installed-files.txt && chmod 755 /etc/clues2 && chmod -R 644 /etc/clues2/* && chmod 755 /etc/clues2/conf.d
RUN cd /opt/ && wget https://github.com/grycap/clues/archive/information-system.zip -O clues.zip && unzip clues.zip && cd clues-information-system && python setup.py install --record installed-files.txt && chmod 755 /etc/clues2 && chmod -R 644 /etc/clues2/* && chmod 755 /etc/clues2/conf.d

# -------------------------------------------------------------------
# This is the part that engages EC4Docker with CLUES
# -------------------------------------------------------------------

# First we install the plugin
ADD cluesfiles/ec4docker.py /usr/local/lib/python2.7/dist-packages/cluesplugins/

# Add the start of CLUES to the bootstrapping process
ADD cluesfiles/50CLUES /opt/ec4docker/conf.d/

# -------------------------------------------------------------------
# This is the part that integrates SLURM and CLUES
# -------------------------------------------------------------------
RUN mv /usr/local/bin/sbatch /usr/local/bin/sbatch.o && mv /usr/local/bin/clues-slurm-wrapper /usr/local/bin/sbatch

ADD slurmfiles/49CLUESSlurm /opt/ec4docker/conf.d/

# Now we put a configuration for CLUES
ADD slurmfiles/clues2.cfg /etc/clues2/
ADD slurmfiles/plugin-slurm.cfg /etc/clues2/conf.d/
