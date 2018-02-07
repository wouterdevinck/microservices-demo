

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

When this is done, it should print the url of your deployed application. Open it in a browser and try the task list demo app, this time running in the cloud.

### Step 6: Cleanup

To remove your deployments from the Kubernetes cluster, run:

```bash
make destroy
```

## Digging deeper

### ...

In "**production**" mode:
```bash
make serve
```

Or in "**development**" mode:
```bash
make start
```