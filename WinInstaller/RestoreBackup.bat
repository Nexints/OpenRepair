@echo off
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f
echo Restoring Files! (Stage 5)
robocopy C:\RestoreBackup\Music "%userprofile%\Music" /e /v /eta /bytes /r:5 /w:1 /zb /j /move
robocopy C:\RestoreBackup\Downloads "%userprofile%\Downloads" /e /v /eta /bytes /r:5 /w:1 /zb /j /move
robocopy C:\RestoreBackup\Documents "%userprofile%\Documents" /e /v /eta /bytes /r:5 /w:1 /zb /j /move
robocopy C:\RestoreBackup\Videos "%userprofile%\Videos" /e /v /eta /bytes /r:5 /w:1 /zb /j /move
robocopy C:\RestoreBackup\Pictures "%userprofile%\Pictures" /e /v /eta /bytes /r:5 /w:1 /zb /j /move
robocopy C:\RestoreBackup\Desktop "%userprofile%\Desktop" /e /v /eta /bytes /r:5 /w:1 /zb /j /move
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v PostInstall /f
cls
echo Scanning System! (Stage 6)
sfc /scannow
dism /online /cleanup-image /restorehealth
sfc /scannow
echo Done!
cd /d C:\RestoreBackup
cd Applications
start Install.bat
xcopy Background.bmp %windir%\System32 /i /v
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\System32\Background.bmp" /f
cd /d %windir%
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
cd /d C:\RestoreBackup
del PostInstall.bat
exit