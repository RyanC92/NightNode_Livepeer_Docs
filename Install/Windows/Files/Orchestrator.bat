@echo off
:Restart

TITLE Orchestrator

.\livepeer-windows-amd64\livepeer.exe -config livepeer_orchestrator.conf

goto Restart
pause