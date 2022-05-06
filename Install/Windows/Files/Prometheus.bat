@echo off
:Restart

TITLE Prometheus

.\Prometheus\Prometheus.exe --config.file=.\prometheus.yml --storage.tsdb.path=".\prometheus\data\ --storage.tsdb.retention.time=1y

goto Restart
pause