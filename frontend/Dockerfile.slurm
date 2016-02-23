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

FROM ec4docker:frontend
MAINTAINER Carlos de Alfonso <caralla@upv.es>

# -------------------------------------------------------------------
# This is the part to install the packages
# -------------------------------------------------------------------

# Packages to install slurm
RUN apt-get update && apt-get install -y libmunge2 libpq5 openssl-blacklist munge libmunge-dev gcc make

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
# This is the part that integrates SLURM and CLUES
# -------------------------------------------------------------------

RUN mv /usr/local/bin/sbatch /usr/local/bin/sbatch.o && mv /usr/local/bin/clues-slurm-wrapper /usr/local/bin/sbatch
ADD slurmfiles/49CLUESSlurm /opt/ec4docker/conf.d/

# Now we put a configuration for CLUES
ADD slurmfiles/clues2.cfg /etc/clues2/
ADD slurmfiles/plugin-slurm.cfg /etc/clues2/conf.d/
