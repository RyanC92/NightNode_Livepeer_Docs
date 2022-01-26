#!/bin/bash

#move to home directory
cd $HOME

#create directory for setup
mkdir livepeersetup
cd livepeersetup/

#install sudo (for minimal installs
apt-get update -y && apt-get install sudo  apt-transport-https software-properties-common gnupg2 wget -N -y

#Download Prometheus, grafana and necessary dependencies

wget -N https://github.com/prometheus/prometheus/releases/download/v2.32.1/prometheus-2.32.1.linux-amd64.tar.gz
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.yml
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer.service
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.yml
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/orchestrator.target
wget -N https://github.com/livepeer/go-livepeer/releases/latest/download/livepeer-linux-amd64.tar.gz
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.service
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeerOTsplit.service

#Install Livepeer
tar -xvzf livepeer-linux-amd64.tar.gz
# renaming livepeer-linux-amd64 to livepeer
mv livepeer-linux-amd64 livepeer

wget -N -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_orchestrator.conf
wget -N -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_transcoder.conf
wget -N -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_orchestratorcombo.conf

#rename old livepeer and prometheus folders in /usr/local/bin to .bak incase they exist
mv /etc/livepeer /etc/livepeer.bak
mv /etc/prometheus /etc/prometheus.bak

#relocate livepeer and service files to their directories
echo "relocating livepeer and service files"

sudo mv livepeer/ /etc/
sudo mv livepeer.service prometheus.service orchestrator.target livepeerOTsplit.service /etc/systemd/system/


#Prometheus Setup 
tar -xvzf prometheus-2.32.1.linux-amd64.tar.gz
# this is to rename it if you want.
mv prometheus-2.32.1.linux-amd64 prometheus

#Create Prometheus/livepeer user account, copy the yml file and take ownership.
sudo groupadd prometheus
sudo groupadd livepeer
sudo useradd --system -g prometheus --home /var/lib/prometheus prometheus
sudo useradd --system -g livepeer --home /var/lib/livepeer livepeer

sudo mkdir -p {/var/lib/livepeer/, /home/livepeer/.lpData/, /var/lib/prometheus, /etc/prometheus}

sudo chown -R livepeer:livepeer /var/lib/livepeer/ /etc/livepeer/ /home/livepeer/
sudo chown -R prometheus:prometheus /var/lib/prometheus /etc/prometheus/

sudo mv prometheus.yml /etc/prometheus/
sudo mv prometheus/ /etc/


#Download and install grafana
#remove old grafana packages if they exist, multiple runs of this script will pile up duplicates.
sudo rm /etc/apt/sources.list.d/grafana.list 
wget -N -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update -y
sudo apt-get install grafana-enterprise -y



#Cleanup
cd $HOME
rm $HOME/livepeersetup/ -r

#downloading part 2 to enable and start the services, edit this file if you want to start a transcoder service only.
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/Livepeer_Setup_Services.sh
#download updater, this will always download, stop services, copy the files over and restart services for the latest version.
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Maintenance/Linux/Update/livepeer_update.sh

chmod +x Livepeer_Setup_Services.sh livepeer_update.sh

echo "Now that this is done, modify the config files in '/etc/livepeer/' to match your configuration"
echo "After modify the livepeer.service or livepeerOTsplit.service if applicable in '/etc/systemd/system/'"
echo "Livepeer_setup_Services.sh is available to start and enable your services, this does not include the livepeerOTsplit.service" 
