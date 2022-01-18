#Script to remove Nightnodes services and files. (This will remove Prometheus and livepeer as well)

sudo rm /usr/local/bin/livepeer/ /usr/local/bin/prometheus/ /etc/prometheus/

cd /etc/systemd/system/

sudo systemctl disable livepeer.service orchestrator.target transcoder.target prometheus.service transcoder.service

sudo rm orchestrator.target livepeer.service prometheus.service transcoder.target transcoder.service