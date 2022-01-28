#!/bin/bash
cd $home
mkdir -p migration
cd migration
mkdir -p prometheus .lpData livepeer home/.lpData

cd.. 

sudo systemctl stop prometheus.service
sudo systemctl stop livepeer.service

cp /etc/prometheus/ $HOME/migration/prometheus/ -r
cp /var/lib/livepeer/.lpData/ $HOME/migration/.lpData/ -r
cp /etc/livepeer/ $HOME/migration/livepeer/ -r
cp /home/livepeer/.lpData/ $HOME/migration/home/.lpData/ -r

sudo tar -czvf livepeer_migration.tar.gz /migration/
