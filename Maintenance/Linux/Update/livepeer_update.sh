#!/bin/bash

#move to home directory
cd $HOME

#create directory for setup
mkdir livepeersetup
cd livepeersetup/

#install sudo (for minimal installs
apt-get update -y && apt-get install sudo  apt-transport-https software-properties-common gnupg2 wget -N -y

wget -N https://github.com/livepeer/go-livepeer/releases/latest/download/livepeer-linux-amd64.tar.gz

#Install Livepeer
tar -xvzf livepeer-linux-amd64.tar.gz
# renaming livepeer-linux-amd64 to livepeer
mv livepeer-linux-amd64 livepeer

sudo systemctl stop livepeer.service orchestrator.target

#copy new version into livepeer directory
sudo cp livepeer/* /etc/livepeer

cd $HOME
rm $HOME/livepeersetup/ -r

#restart livepeer services
sudo systemctl start orchestrator.target livepeer.service
