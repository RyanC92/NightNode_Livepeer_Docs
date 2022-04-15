@echo off
:Restart

TITLE NVidia_Exporter

start /d "C:\Program Files\Go\Bin\" gofmt.exe 
go run .\nvidia_exporter.go

goto Restart
