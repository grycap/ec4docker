#!/usr/bin/env python
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
import logging
from clueslib.platform import PowerManager_cmdline
import cpyutils.config

_LOGGER=logging.getLogger("[EC4DOCKER]")

try:
    config_ec4docker
except:
    config_ec4docker = cpyutils.config.Configuration(
        "EC4DOCKER",
        {
            "EC4DOCKER_CMDLINE_POWON": "",
            "EC4DOCKER_CMDLINE_POWOFF" : "",
        }
    )

class powermanager(PowerManager_cmdline):
    def __init__(self):
        PowerManager_cmdline.__init__(self, config_ec4docker.EC4DOCKER_CMDLINE_POWON, config_ec4docker.EC4DOCKER_CMDLINE_POWOFF, None)