@echo off

:Restart 

TITLE Livepeer Transcoder

.\livepeer-windows-amd64\livepeer.exe -config livepeer_orchestrator.conf


goto restart

