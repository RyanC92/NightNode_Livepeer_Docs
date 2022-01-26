#!/bin/bash

#move to home directory
cd $HOME

#create directory for setup
mkdir livepeersetup
cd livepeersetup/

#install sudo (for minimal installs
apt-get update -y && apt-get install sudo  apt-transport-https software-properties-common gnupg2 wget -N -y

wget -N https://github.com/livepeer/go-livepeer/releases/latest/download/livepeer-linux-amd64.tar.gz

#Extract Livepeer
"Extract livepeer from livepeer-linux-amd64.tar.gz"
tar -xvzf livepeer-linux-amd64.tar.gz


echo "Stopping Services"
sudo systemctl stop livepeer.service orchestrator.target

#copy new version into livepeer directory
echo "Copying to directory '/etc/livepeer'"
sudo cp livepeer-linux-amd64/* /etc/livepeer

cd $HOME
rm $HOME/livepeersetup/ -r

#restart livepeer services
echo "Restarting Services"
sudo systemctl start orchestrator.target livepeer.service
