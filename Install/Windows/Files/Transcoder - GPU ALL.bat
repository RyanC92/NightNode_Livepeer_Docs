@echo off

:Restart 

TITLE Livepeer Transcoder

.\Binaries\livepeer.exe -config "livepeer_transcoder - GPU ALL.conf"


goto restart

