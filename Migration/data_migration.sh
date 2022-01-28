#!/bin/bash
cd $home
mkdir -p migration
cd migration
mkdir -p prometheus .lpData livepeer home/.lpData

cd.. 

sudo systemctl stop prometheus.service
sudo systemctl stop livepeer.service

cp /etc/prometheus/ $home/migration/prometheus/ -r
cp /var/lib/livepeer/.lpData/ $home/migration/.lpData -r
cp /etc/livepeer/ $home/migration/livepeer/ -r
cp /home/livepeer/.lpData/ $home/migration/home/.lpData/ -r

sudo tar -czvf livepeer_migration.tar.gz /migration/
