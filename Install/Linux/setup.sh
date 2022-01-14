#!/bin/bash

#move to home directory
cd $HOME

#install sudo (for minimal installs
apt-get update -y && apt-get install sudo  apt-transport-https software-properties-common wget -y

#Download Prometheus, grafana and necessary dependencies

wget https://github.com/prometheus/prometheus/releases/download/v2.32.1/prometheus-2.32.1.linux-amd64.tar.gz
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.yml
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer.service
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Prometheus/prometheus.yml
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/orchestrator.target
wget https://github.com/livepeer/go-livepeer/releases/download/v0.5.25/livepeer-linux-amd64.tar.gz

#Install Livepeer
tar -xvzf livepeer-linux-amd64.tar.gz
# this is to rename it if you want.
mv livepeer-linux-amd64 livepeer

wget -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_orchestrator.conf
wget -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer_transcoder.conf
wget -P livepeer/ https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/livepeer.sh

#set livepeer.sh to execute
chmod +x livepeer/livepeer.sh

sudo mv livepeer /usr/local/bin/ -r
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
sudo mv prometheus /usr/local/bin/ -r
sudo chown -R prometheus:prometheus /etc/prometheus/
sudo mv prometheus.service /etc/systemd/system/

#Download and install grafana
echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install grafana-enterprise -y

#Cleanup
cd $HOME

rm livepeer-linux-amd64.tar.gz prometheus-2.32.1.linux-amd64.tar.gz prometheus.service -r
