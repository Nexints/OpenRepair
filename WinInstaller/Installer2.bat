@echo off
powershell -ExecutionPolicy Bypass -Command "Start-Process cmd -Verb RunAs -ArgumentList '/c "%var%"\Installer1.bat'"
echo %var%\Installer1.bat
exit