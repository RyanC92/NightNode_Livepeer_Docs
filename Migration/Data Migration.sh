#!/bin/bash
cd $home
mkdir migration


sudo systemctl stop prometheus.service
sudo systemctl stop livepeer.service

cp /etc/prometheus/* migration/prometheus/
cp /var/lib/livepeer/.lpData/ /migraiton/.lpData/
cp /etc/livepeer/ /migration/livepeer/
cp /home/livepeer/.lpData/ /migration/home/.lpData/

sudo tar -czvf livepeer_migration.tar.gz /migration/