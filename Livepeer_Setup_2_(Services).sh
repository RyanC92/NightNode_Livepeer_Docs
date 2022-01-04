#!/bin/bash

#Start and enable all the services once the configurations have been made
sudo systemctl daemon-reload
sudo systemctl start prometheus.service grafana-server livepeer.service orchestrator.target
sudo systemctl enable prometheus.service grafana-server.service livepeer.service orchestrator.target
