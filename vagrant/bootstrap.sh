#!/bin/bash
set -e
set -x

# Variables
NEWUSERNAME="student"

# Add/remove users
adduser --disabled-password --gecos "" $NEWUSERNAME
sudo passwd -d $NEWUSERNAME
sudo usermod -aG sudo $NEWUSERNAME
echo "$NEWUSERNAME ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
sudo deluser --remove-home ubuntu

# Edit hosts
echo "127.0.1.1 ubuntu ubuntu" | sudo tee -a /etc/hosts

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
sudo apt-get install -y docker-ce
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
sudo apt-get install -y code

# Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install NodeJS
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Postman
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
sudo tar -xzf postman.tar.gz -C /opt
rm postman.tar.gz
sudo ln -s /opt/Postman/Postman /usr/bin/postman
mkdir -p /home/$NEWUSERNAME/.local/share/applications/
cat > /home/$NEWUSERNAME/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL

# Install Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update 
sudo apt-get install google-chrome-stable

# Desktop shortcuts
cp /usr/share/applications/gnome-terminal.desktop /home/$NEWUSERNAME/Desktop/
cp /usr/share/applications/code.desktop /home/$NEWUSERNAME/Desktop/
cp /usr/share/applications/google-chrome.desktop /home/$NEWUSERNAME/Desktop/
cp /home/$NEWUSERNAME/.local/share/applications/postman.desktop /home/$NEWUSERNAME/Desktop/
sudo chmod 750 -R /home/$NEWUSERNAME/Desktop/

# Install relevant Visual Studio Code extensions
echo "code --install-extension PeterJausovec.vscode-docker" >> /home/$NEWUSERNAME/.bashrc

# Uninstall LibreOffice and other bloat to reclaim some disk space
sudo apt-get remove -y --purge libreoffice*
sudo apt-get remove -y --purge account-plugin-* 
sudo apt-get remove -y --purge aisleriot brltty colord deja-dup deja-dup-backend-gvfs duplicity \
  empathy empathy-common evolution-data-server-online-accounts example-content firefox \
  gnome-accessibility-themes gnome-contacts gnome-mahjongg gnome-mines gnome-orca gnome-screensaver \
  gnome-sudoku gnome-video-effects gnomine landscape-common libsane libsane-common mcp-account-manager-uoa \
  python3-uno rhythmbox rhythmbox-* sane-utils shotwell shotwell-common telepathy-* thunderbird thunderbird-* \
  totem totem-* unity-scope-* unity-webapps-common
sudo apt-get clean -y
sudo apt-get autoremove -y

# Reboot
sudo reboot