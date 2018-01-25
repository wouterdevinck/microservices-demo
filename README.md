# Dockerized microservices demo

## Setting up your development environment

In general, only *Docker Engine* and *Docker Compose* are required. *Visual Studio Code* is handy as an IDE, but _notepad_ or _vi_ will also get the job done. *Git* is handy to clone this repos in the first place.

### Windows

 * Install Docker CE for Windows (includes Compose): https://docs.docker.com/docker-for-windows/install/
 * Optionally, install Git: https://git-scm.com/download/win
 * Optionally, install Visual Studio Code: https://code.visualstudio.com/

### Mac
_Untested_

 * Install Docker CE for Mac (includes Compose): https://docs.docker.com/docker-for-mac/install/
 * Optionally, install Git: https://git-scm.com/download/mac
 * Optionally, install Visual Studio Code: https://code.visualstudio.com/

### Ubuntu

 * Install Docker CE for Ubuntu (read carefully): https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
 * Have a look at the optional post-install steps ("Manage Docker as a non-root user" is recommended): https://docs.docker.com/engine/installation/linux/linux-postinstall/
 * Install Docker Compose: https://docs.docker.com/compose/install/ (see "Linux" tab)
 * Optionally, install Git: `sudo apt-get install git-all` 
 * Optionally, install Visual Studio Code: https://code.visualstudio.com/

### Other Linux distributions
_Untested_

 * Install Docker CE for your distribution: https://docs.docker.com/engine/installation/
 * Install Docker Compose: https://docs.docker.com/compose/install/ (see "Linux" tab)
 * Optionally, install Git: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
 * Optionally, install Visual Studio Code: https://code.visualstudio.com/

## Getting the code

### Using Git

In bash or PowerShell, run:

```bash
git clone https://github.com/wouterdevinck/microservices-demo.git
```

Interactive tutorial if you are new to git: https://try.github.io

### Alternative: direct download

Download and unzip:
https://github.com/wouterdevinck/microservices-demo/archive/develop.zip

## Running all microservices on your computer

In bash or PowerShell, run:

```bash
docker-compose up
```

## Running all microservices on Kubernetes

```bash
TODO
```