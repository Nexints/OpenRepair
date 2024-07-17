@echo off
powershell -ExecutionPolicy Bypass -Command "Start-Process cmd -Verb RunAs -ArgumentList '/c C:\RestoreBackup\RestoreBackup.bat'"
exit