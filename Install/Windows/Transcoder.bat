@echo off

:Restart 

TITLE Transcoder

C:\LivepeerTranscoder\Livepeer.exe -config "livepeer_transcoder.conf"

goto restart

