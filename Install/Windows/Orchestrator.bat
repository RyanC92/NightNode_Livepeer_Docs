@echo off
:Restart

TITLE Orchestrator

.\livepeer.exe -config livepeer_orchestrator.conf

goto Restart
pause