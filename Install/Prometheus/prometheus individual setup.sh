#!/bin/bash
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir -p /etc/prometheus/
sudo cp prometheus.yml /etc/prometheus/
sudo cp prometheus/ /etc/ -r
sudo chown -R prometheus:prometheus /etc/prometheus/
cp prometheus.service /etc/systemd/system/
