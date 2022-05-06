@echo off

:Restart 

TITLE Livepeer Transcoder

.\Binaries\livepeer.exe -config livepeer_orchestrator.conf


goto restart

