#!/bin/bash
set -e
set -x

# Variables
NEWUSERNAME="student"

# Add/remove users
adduser --disabled-password --gecos "" $NEWUSERNAME
sudo passwd -d $NEWUSERNAME
sudo usermod -aG sudo $NEWUSERNAME
su - $NEWUSERNAME
sudo deluser --remove-home ubuntu

# Update package source
sudo apt-get update

# Install VirtualBox guest additions
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# Install a desktop (since we start from a cloud image)
sudo apt-get install -y ubuntu-desktop

# Install GIT
sudo apt-get install -y git

# Install GNU Make
sudo apt-get install -y make

# Install Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
sudo groupadd docker
sudo usermod -aG docker $NEWUSERNAME
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Visual Studio Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install code

# Install relevant Visual Studio Code extensions
code --install-extension PeterJausovec.vscode-docker

# Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install NodeJS (optional)
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# Uninstall LibreOffice to reclaim some disk space
sudo apt-get remove --purge libreoffice*
sudo apt-get clean
sudo apt-get autoremove

# Reboot
sudo reboot