#!/bin/bash

#move to home directory
cd $HOME

#create directory for setup
mkdir livepeersetup/
cd livepeersetup/

#install sudo (for minimal installs
apt-get update -y && apt-get install sudo  apt-transport-https software-properties-common wget -N -y

#Download Prometheus, grafana and necessary dependencies

wget -N https://github.com/prometheus/prometheus/releases/download/v2.32.1/prometheus-2.32.1.linux-amd64.tar.gz
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.yml
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer.service
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.yml
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/orchestrator.target
wget -N https://github.com/livepeer/go-livepeer/releases/download/v0.5.25/livepeer-linux-amd64.tar.gz
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.service
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/transcoder.service
wget -N https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/transcoder.target

#Install Livepeer
tar -xvzf livepeer-linux-amd64.tar.gz
# renaming livepeer-linux-amd64 to livepeer
mv livepeer-linux-amd64 livepeer

wget -N -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_orchestrator.conf
wget -N -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_transcoder.conf
wget -N -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_orchestratorcombo.conf

#rename old livepeer and prometheus folders in /usr/local/bin to .bak incase they exist
mv /usr/local/bin/livepeer /usr/local/bin/livepeer.bak
mv /usr/local/bin/prometheus /usr/local/bin/prometheus.bak

#relocate livepeer and service files to their directories
echo "relocating livepeer and service files"

sudo mv livepeer /usr/local/bin/
sudo mv livepeer.service transcoder.service transcoder.target prometheus.service orchestrator.target /etc/systemd/system/


#Prometheus Setup 
tar -xvzf prometheus-2.32.1.linux-amd64.tar.gz
# this is to rename it if you want.
mv prometheus-2.32.1.linux-amd64 prometheus

#Create Prometheus/livepeer user account, copy the yml file and take ownership.
sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false livepeer
sudo mkdir -p /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/
sudo mv prometheus /usr/local/bin/
sudo chown -R prometheus:prometheus /etc/prometheus/

#Download and install grafana
#remove old grafana packages if they exist, multiple runs of this script will pile up duplicates.
sudo rm /etc/apt/sources.list.d/grafana.list 
echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
wget -N -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install grafana-enterprise -y

#Cleanup
cd $HOME
rm $HOME/livepeersetup/ -r

