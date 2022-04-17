@echo off

:Restart 

TITLE Transcoder - 3080 TI

.\livepeer-windows-amd64\Livepeer.exe -config "Livepeer_Transcoder - GPU2.conf"

goto restart