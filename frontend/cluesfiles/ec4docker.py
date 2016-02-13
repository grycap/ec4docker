#!/usr/bin/env python
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