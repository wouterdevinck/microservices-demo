# Dockerized microservices demo

## Setup development virtual machine

 1. **Download** [this .ova file](https://drive.google.com/open?id=1SGMkOM16DFN8HcQ4X6Ue3g5flHL010f3) _(2.5 GB)_
 2. **Install** [VirtualBox](http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html)
 3. **Import** the virtual machine:
	 1. Open VirtualBox
	 2. File &raquo; Import appliance...
	 3. Select .ova file &raquo; Next
	 4. Make sure to tick the box "Reinitialize MAC address"
	 5. Click "Import"
 4. **Run** the machine by double clicking it

_(if you are curious how this .ova was created, have a look at the [vagrant](vagrant) directory in this repo)_

## Quickstart

### Step 1: Clone this git repo

Open a terminal on the development VM and run:

 ```bash
git clone https://github.com/wouterdevinck/microservices-demo.git
cd microservices-demo
```

### Step 2: Build and run the microservices locally

```bash
make serve
```

This uses Docker Compose to build and run all microservices defined in [docker-compose.yml](docker-compose.yml)

If all went well, you should be able to browse to ```http://localhost:4300``` and try the task list demo app.

To stop the running microservices, press *CRTL+C* to exit Docker Compose, and run:

```bash
make stop
```

### Step 3: Sign in to Kubernetes & Docker Hub

```bash
make login
```
You will be prompted for your username and password.

### Step 4: Upload the microservices built in step 2 to Docker Hub

```bash
make publish
```

### Step 5: Deploy these microservices to the Kubernetes cluster

```bash
make deploy
```

Once this is done, it should print the url of your deployed application. Open it in a browser and try the task list demo app, this time running in the cloud.

### Step 6: Cleanup

To remove your deployments from the Kubernetes cluster:

```bash
make destroy
```

## Digging deeper

### Building and running locally

To build all Docker images (both "development" and "production") without running them:

```bash
make
```

To build & run all in "**production**" mode (_uses [docker-compose.yml](docker-compose.yml)_):
```bash
make serve
```

To build & run all  in "**development**" mode (_uses [docker-compose-dev.yml](docker-compose-dev.yml)_):
```bash
make start
```

In development mode, the source code of the services is mounted as volumes to the Docker containers and the containers run a development webserver, which is automatically restarting when the source code changes. While running in development mode, you can just edit the code in [service-task-api/src](service-task-api/src) and [service-frontend/src](service-frontend/src) in an editor (e.g _Visual Studio Code_) and test your changes immediately in a browsers.

### Development helpers

While running in development mode, it can be handy to open a second tab in your terminal to run commands directly in the running Docker containers (e.g. ```npm install ...```). The [Makefile](Makefile) has some targets to make this simple:

####  Getting an interactive shell

To get a shell in one of the running Docker containers, use ```make shell <name>```, e.g.:
```bash
make shell task-api
```
```bash
make shell frontend
```
To exit this interactive shell:
```bash
exit
```

#### Running a single command

To run a command in one of the running Docker containers, use ```make exec <name> <command>```, e.g.:
```bash
make exec frontend npm version
```
To run ```npm version``` in the Docker image called "frontend"

Note that _make_ does not play nice with arguments that start with dashes, so to run things like ```npm install --save-dev ...```, use ```make shell <name>``` instead.

### Native tools

The [Makefile](Makefile) simply calls a few different tools. You can also use these tools directly. Below are some handy commands that are not covered in the Makefile (see the [file](Makefile) itself for this that _are_ covered).

#### Docker

List all Docker containers
```bash
docker ps -a
```

List all Docker images:
```bash
docker images
```

Also see the [the docker website](https://docs.docker.com/engine/reference/commandline/cli/).

#### Kubernetes

Note that you will need to run ```make login``` first to configure ```kubectl``` with the right secrets to talk to the Kubernetes cluster.

List all deployments, pods, replica sets, services, ingresses, etc.:
```bash
kubectl get all,ing
```

Also see the [kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/).