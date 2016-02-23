# EC4Docker (Elastic Cluster for Docker)

__EC4Docker__ is a simple Elastic Cluster whose nodes are contaniers. There exists a front-end that can be accessed by ssh, and the internal _working nodes_ are powered on or off according to the needs (if the nodes are not used for a while, they are powered off, and they are powered on if they are needed).

Features of the cluster:
- Front end that has SSH access.
- Passwordless SSH access from frontend to the working nodes.
- Customizable number of working nodes.
- Self-managed elasticity by using [CLUES](https://github.com/grycap/clues).
- Shared filesystem from frontend to working nodes by using NFS

EC4Docker may seem a bit useless because it is currently deployed on a single cluster, but consider its integration with [Docker Swarm](https://www.docker.com/products/docker-swarm) and you'll have an Elastic Cluster that is deployed over a multi-node infrastructure.

## How to use it
1. Create your front-end and working node docker images.
2. Edit the _ec4docker.config_ file to configure the cluster.
3. Use _setup-cluster_ script to start the cluster.
4. Enter into the cluster.
 
## Building the docker images
In first place, you need to chose the cluster manager middleware. Torque and SLURM are currently available, but you can create your own Dockerimage files according to your specific middleware.

Once selected, you need to build the build the _front-end_ and _working node_ base images by issuing the following commands:

```bash
docker build -f frontend/Dockerfile.clues -t ec4docker:frontend ./frontend/
docker build -f wn/Dockerfile.wn -t ec4docker:wn wn/
```

Then you need to create the images that correspond to the middleware:
* For the case of Torque, you can use the following commands:
```bash
docker build -f frontend/Dockerfile.torque -t ec4dtorque:frontend ./frontend/
docker build -f wn/Dockerfile.torque -t ec4dtorque:wn wn/
```

* For the case of SLURM, you can use the following commands:
```bash
docker build -f frontend/Dockerfile.slurm -t ec4dslurm:frontend ./frontend/
docker build -f wn/Dockerfile.slurm -t ec4dslurm:wn wn/
```

The images will be built and registered in your local registry.

Alternatively you can build the non-elastic version: by not installing CLUES in the frontend. In order to make it, you can create the base images issuing the following commands:

```bash
docker build -f frontend/Dockerfile.static -t ec4docker:frontend ./frontend/
docker build -f wn/Dockerfile.wn -t ec4docker:wn wn/
```

In this case you need to power the nodes on or of by hand (using the provided scripts in folder _/opt/ec4docker_).

__NOTE__: you are advised to modify the Dockerfile files in order to include your libraries, applications, etc. to customize your cluster. Another option is to build the provided Dockerfiles and create your owns that start from the created one (you can check the _FROM_ clause in the Dockerfile file).

## Configure the cluster
You should create a config file (_ec4docker.config_) to set the name of your cluster (this name will be set for the front-end node in docker), the base name for the working nodes (they should be named as _basename_1, _basename_2, etc.) and the max amount of computing nodes. You must also set the names of the docker images according to the previous step.

Two examples are provided:
* The file _ec4docker-torque.config_ for the case of Torque:
```bash
EC4DOCK_SERVERNAME=ec4docker
EC4DOCK_MAXNODES=4
EC4DOCK_FRONTEND_IMAGENAME=ec4dtorque:frontend
EC4DOCK_WN_IMAGENAME=ec4dtorque:wn
EC4DOCK_NODEBASENAME=ec4dockernode
```

* And the file _ec4docker-slurm.config_ for the case of Torque:
```bash
EC4DOCK_SERVERNAME=ec4docker
EC4DOCK_MAXNODES=4
EC4DOCK_FRONTEND_IMAGENAME=ec4dslurm:frontend
EC4DOCK_WN_IMAGENAME=ec4dslurm:wn
EC4DOCK_NODEBASENAME=ec4dockernode
```

__NOTE__: In this file the cluster will be named _ec4docker_ and the maximum number of working nodes is set to 4. You are advised to change the name of your frontend and the amount of working nodes that will be available.

## Create the cluster
You can use the script _setup-cluster_ to create the front-end of the cluster, from the corresponding docker image. If the cluster already exists, this script will ask you to kill it.

__IMPORTANT__: In order to be able to use the NFS shared filesystem, you __MUST__ enable nfsd module in the kernel of the docker servers that hosts the containers.
```bash
$ modprobe nfsd
```

In order to create your cluster, defined in _ec4docker-torque.config_ file, you can issue the following command:
```bash
$ ./setup-cluster -f ec4docker-torque.config
```

__NOTE__: The settings of the clusters are those that are set in file _ec4docker-torque.config_ file. Take note of those settings because you will need them in order to access the cluster. In special, the name of the cluster which is in _EC4DOCK_SERVERNAME_.

__WARNING__: The cluster is created on a _Docker aside Docker_ approach. That means that the front-end will issue docker calls to create and to destroy the docker containers that will serve as working nodes from the cluster. But these docker containers will be created in the docker host that started the front-end. In order to use this approach, the docker communication socket and the docker binary from the host are shared with the container.

## Enter the cluster
Once the front-end has been created you can enter into the front-end container and _su_ as the __ubuntu__ user (which is the only user created in the cluster). An example of the command like is provided next (the name of the container depends on your configuration; i.e. the _ec4docker.config_ file):

```bash
$ docker exec -it ec4docker /bin/bash
root@ec4docker:/$ su - ubuntu
```

Altenatively you can ssh the front-end. The SSH is exposed in the creation of the frontend, so you can guess the port where the front-end will listen by using the _docker port_ command:

```bash
$ docker port ec4docker
22/tcp -> 0.0.0.0:32770
```

In this example, you can ssh to _ubuntu@localhost_ at port _32770_ with a command like the next one (the default password is "ubuntu", and it is set in the Dockerfile):

```bash
$ ssh -p 32770 ubuntu@localhost
```

Now you can issue commands to the queue, and CLUES will intercept the call and will power on some working nodes in the cluster.

An example is the next:
```bash
$ echo "hostname && sleep 10" | qsub
1.ec4docker
$ qstat                             
Job id                    Name             User            Time Use S Queue
------------------------- ---------------- --------------- -------- - -----
1.ec4docker               STDIN            ubuntu                 0 R batch 
$ ls -l
total 4
-rw------- 1 ubuntu ubuntu  0 Feb 12 11:15 STDIN.e1
-rw------- 1 ubuntu ubuntu 13 Feb 12 11:15 STDIN.o1
```

__NOTE__: For the non-elasic version, you can power on some nodes from inside the front-end, by hand by issuing commands like the next:
```bash
$ /opt/ec4docker/poweron ec4dockernode1
$ /opt/ec4docker/poweron ec4dockernode2
```

## Troubleshooting

If any of the docker containers fail (for any reason), please check the output of the command ```docker logs <container>```.

Some common issues are:
- __Docker fails at removing a container__ (i.e. docker rm command fails) because it is in use. In this case you __need to__ try to remove the container by hand or (under some circumnstances) restart the docker daemon.
- __The nfsd module is not enabled__ and then the mount point for the working nodes is not enabled. Torque cannot write in the shared folder and the execution of commands fail. In this case you should try to enable nfsd module and restart the cluster in order to execute the bootstrapping process again.
