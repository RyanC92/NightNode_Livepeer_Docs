#!/bin/bash

#move to home directory
cd $HOME

#install sudo (for minimal installs
apt-get update -y && apt-get install sudo  apt-transport-https software-properties-common wget -N -C -y

#Download Prometheus, grafana and necessary dependencies

wget -N -C https://github.com/prometheus/prometheus/releases/download/v2.32.1/prometheus-2.32.1.linux-amd64.tar.gz
wget -N -C https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.yml
wget -N -C https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer.service
wget -N -C https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.yml
wget -N -C https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/orchestrator.target
wget -N -C https://github.com/livepeer/go-livepeer/releases/download/v0.5.25/livepeer-linux-amd64.tar.gz
wget -N -C https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.service
wget -N -C https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/transcoder.service

#Install Livepeer
tar -xvzf livepeer-linux-amd64.tar.gz
# this is to rename it if you want.
mv livepeer-linux-amd64 livepeer

wget -N -C -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_orchestrator.conf
wget -N -C -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_transcoder.conf
wget -N -C -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_orchestratorcombo.conf

sudo mv livepeer /usr/local/bin/
sudo mv livepeer.service /etc/systemd/system/
sudo mv orchestrator.target /etc/systemd/system

#Prometheus Setup 
tar -xvzf prometheus-2.32.1.linux-amd64.tar.gz
# this is to rename it if you want.
mv prometheus-2.32.1.linux-amd64 prometheus

#Create Prometheus user account, copy the yml file, setup the service and take ownership.
sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false livepeer
sudo mkdir -p /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/
sudo mv prometheus /usr/local/bin/
sudo chown -R prometheus:prometheus /etc/prometheus/
sudo mv prometheus.service /etc/systemd/system/

#Download and install grafana
echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
wget -N -C -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install grafana-enterprise -y

#Cleanup
cd $HOME

rm livepeer-linux-amd64.tar.gz prometheus-2.32.1.linux-amd64.tar.gz prometheus.service setup.sh prometheus prometheus.yml livepeer.service orchestrator.target -r
