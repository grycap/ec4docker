#! /usr/bin/env python
# coding: utf-8
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
from distutils.core import setup
from version import VERSION

# How to install:
# $ git clone https://github.com/grycap/ec4docker
# $ cd ec4docker
# $ sudo python setup.py install --record installed-files.txt


setup(name='ec4docker',
      version=VERSION,
      description='Elastic Cluster for Docker',
      author='Carlos de Alfonso',
      author_email='caralla@upv.es',
      url='http://github.com/grycap/ec4docker',
      scripts = [ 'ec4docker' ],
      download_url = 'https://github.com/grycap/ec4docker',
)
