
# Dockerized microservices demo

 1. dd
		1. dd

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