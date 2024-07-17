@echo off
echo This CMD prompt is intentional. Please do NOT close this cmd prompt.
echo This CMD prompt skips the OOBE experience on Windows 10/11.
echo Windows 8.1 requires a reset after getting ready
echo and has an infinite boot screen...
oobe\windeploy
net user /add Admin
net localgroup /add users Admin
net localgroup /add administrators Admin
reg add "HKLM\System\Setup" /v OOBEInProgress /t REG_DWORD /d 0 /f
reg add "HKLM\System\Setup" /v SetupType /t REG_DWORD /d 0 /f
reg add "HKLM\System\Setup" /v SystemSetupInProgress /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f