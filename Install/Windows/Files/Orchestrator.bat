@echo off
:Restart

TITLE Orchestrator

.\Binaries\livepeer.exe -config livepeer_orchestrator.conf

goto Restart
pause