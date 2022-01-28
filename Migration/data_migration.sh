#!/bin/bash
cd $home
mkdir -p migration
cd migration
mkdir -p prometheus .lpData livepeer home/.lpData


sudo systemctl stop prometheus.service
sudo systemctl stop livepeer.service

cp /etc/prometheus/ migration/prometheus/ -r
cp /var/lib/livepeer/.lpData/ /migraton/.lpData -r
cp /etc/livepeer/ /migration/livepeer/ -r
cp /home/livepeer/.lpData/ /migration/home/.lpData/ -r

sudo tar -czvf livepeer_migration.tar.gz /migration/
