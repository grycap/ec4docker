# EC4Docker (Elastic Cluster 4 Docker)

__Pending__: integrate with [CLUES](https://github.com/grycap/clues) to self-manage elasticity.

## How to use it
1. Create your front-end and working node docker images. 
2. Edit the _ec4docker.config_ file to configure the cluster.
3. Use _setup-cluster_ script to start the cluster.
4. Enter into the cluster.
 
## Building the docker images
You can build the _front-end_ and _working node_ docker images by issuing the following commands:

```bash
docker build -t torque:frontend frontend
docker build -t torque:wn wn
```

The images will be built and registered in your local registry. Their names are _torque:frontend_ and _torque:wn_.

__Pending__: using other repositories

## Configure the cluster
You should edit the file _ec4docker.config_ file to set the name of your cluster (this name will be set for the front-end node in docker), the base name for the working nodes (they should be named as _basename_1, _basename_2, etc.) and the max amount of computing nodes. You must also set the names of the docker images according to the previous step.

## Create the cluster
You can use the script _setup-cluster_ to create the front-end of the cluster, from the corresponding docker image. If the cluster already exists, this script will ask you to kill it.

__WARNING__: The cluster is created on a _Docker aside Docker_ approach. That means that the front-end will issue docker calls to create and to destroy the docker containers that will serve as working nodes from the cluster. But these docker containers will be created in the docker host that started the front-end. In order to use this approach, the docker communication socket and the docker binary from the host are shared with the container.

## Enter the cluster
Once the front-end has been created you can enter into the front-end container by issuing a command like the next one (the name of the container depends on your configuration; i.e. the _ec4docker.config_ file):

```bash
$ docker exec -it torqueserver /bin/bash
```

Power on some nodes from inside the front-end:
```bash
$ /opt/ec4docker/poweron-wn 1
$ /opt/ec4docker/poweron-wn 2
```

Then you can su as the _ubuntu_ user and try to qsub some commands:
```bash
$ su - ubuntu
$ echo "hostname && sleep 10" | qsub
1.torqueserver
$ qstat                             
Job id                    Name             User            Time Use S Queue
------------------------- ---------------- --------------- -------- - -----
1.torqueserver            STDIN            ubuntu                 0 R batch 
$ ls -l
total 4
-rw------- 1 ubuntu ubuntu  0 Feb 12 11:15 STDIN.e1
-rw------- 1 ubuntu ubuntu 13 Feb 12 11:15 STDIN.o1
```
