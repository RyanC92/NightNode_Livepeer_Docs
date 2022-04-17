@echo off

:Restart 

TITLE Livepeer Transcoder

.\livepeer-windows-amd64\livepeer.exe -config "livepeer_transcoder - GPU ALL.conf"


goto restart

