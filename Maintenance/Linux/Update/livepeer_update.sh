#!/bin/bash

##############################################################################################################################################################
# Please modify this file to fit your services that you are utilizing, this will stop and start services based upon the serivces used in the install scripts #
# and will not automatically conform to your setup!                                                                                                          #
##############################################################################################################################################################

#move to home directory
cd $HOME

#create directory for setup
mkdir livepeersetup
cd livepeersetup/

#install sudo (for minimal installs
apt-get update -y && apt-get install sudo  apt-transport-https software-properties-common gnupg2 wget -N -y

wget -N https://github.com/livepeer/go-livepeer/releases/latest/download/livepeer-linux-amd64.tar.gz

#Extract Livepeer
echo "Extract livepeer from livepeer-linux-amd64.tar.gz"
tar -xvzf livepeer-linux-amd64.tar.gz


echo "Stopping Services, if you see any errors about services not being found, that is fine."
echo "'If' you get cp errors, that is because livepeer is active somehow, check your services, if you have custom services that do not fit what is listed below it will not stop the service"
echo "Modify this script to then list the custom service you are running"
sudo systemctl stop livepeer.service orchestrator.target livepeerOTsplit.service transcoder.service

#copy new version into livepeer directory
echo "Copying to directory '/etc/livepeer'"
sudo cp livepeer-linux-amd64/* /etc/livepeer

cd $HOME
rm $HOME/livepeersetup/ -r

echo "Taking back ownership"
sudo chown -R livepeer:livepeer /etc/livepeer/

#restart livepeer services
echo "Restarting Services"
sudo systemctl start orchestrator.target livepeer.service
