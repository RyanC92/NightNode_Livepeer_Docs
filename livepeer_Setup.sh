#!/bin/bash

#move to home directory
cd $HOME

#Download Prometheus, grafana and necessary dependencies

wget https://github.com/prometheus/prometheus/releases/download/v2.32.1/prometheus-2.32.1.linux-amd64.tar.gz
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/prometheus.yml
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/livepeer.sh
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/livepeer.service
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/prometheus.service
wget https://github.com/livepeer/go-livepeer/releases/download/v0.5.23/livepeer-linux-amd64.tar.gz
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/orchestrator.target

#set livepeer.sh to execute
chmod +x ./livepeer.sh

#Prometheus Setup 
tar -xvzf prometheus-2.32.1.linux-amd64.tar.gz
# this is to rename it if you want.
mv prometheus-2.32.1.linux-amd64 prometheus

#check for updates and install sudo
apt-get update && apt-get -y install sudo

#Create Prometheus user account, copy the yml file, setup the service and take ownership.
sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false livepeer
sudo mkdir -p /etc/prometheus/
sudo cp prometheus.yml /etc/prometheus/
sudo cp prometheus /usr/local/bin/ -r
sudo chown -R prometheus:prometheus /etc/prometheus/
sudo cp prometheus.service /etc/systemd/system/

#setup the services for Prometheus
#sudo systemctl daemon-reload
#sudo systemctl start prometheus.service
#sudo systemctl enable prometheus.service
#sudo systemctl status prometheus.service

#Download and install grafana
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install grafana-enterprise -y

#Start the grafana server with systemd
#sudo systemctl daemon-reload
#sudo systemctl start grafana-server
#sudo systemctl enable grafana-server.service
#sudo systemctl status grafana-server

#Install Livepeer
tar -xvzf livepeer-linux-amd64.tar.gz
# this is to rename it if you want.
mv livepeer-linux-amd64 livepeer

sudo cp livepeer /usr/local/bin/ -r
sudo cp livepeer.sh /usr/local/bin/livepeer/
sudo cp livepeer.service /etc/systemd/system/
sudo cp orchestrator.target /etc/systemd/system


#setup the services for livepeer
#sudo systemctl daemon-reload
#sudo systemctl start livepeer.service
#sudo systemctl enable livepeer.service
#sudo systemctl enable orchestrator.target
#sudo systemctl status prometheus.service


#Cleanup
cd $HOME

rm livepeer-linux-amd64.tar.gz orchestrator.target  prometheus-2.32.1.linux-amd64.tar.gz prometheus.service livepeer livepeer.service livepeer.sh prometheus prometheus.service prometheus.yml -r
