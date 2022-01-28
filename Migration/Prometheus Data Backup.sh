#!/bin/bash
cd $home
mkdir prometheusbackup

cd prometheusbackup/

sudo systemctl stop prometheus.service

sudo tar -czvf prometheus-data.tar.gz /etc/prometheus/

