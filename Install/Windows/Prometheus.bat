@echo off
:Restart

TITLE Prometheus

cd C:\Prometheus\
.\Prometheus.exe --storage.tsdb.retention.time=1y

goto Restart
pause