@echo off
set var=%cd%\
setx var "%cd%\"
set var=%cd%\
xcopy "oobe.bat" "%userprofile%" /y
xcopy "PostInstall.bat" "%userprofile%" /y
xcopy "RestoreBackup.vbs" "%userprofile%" /y
start cmd /c "%var%\Installer2.bat"
exit