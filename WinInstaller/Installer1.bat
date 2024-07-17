@echo off
cd /d %var%

setlocal
:PROMPT
SET /P AREYOUSURE=Do you want to run this unofficial Windows installer? (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

echo list disk> test1.bat
echo exit>> test1.bat
diskpart /s test1.bat

echo.
echo Use CTRL-C at any time to end this script.
echo Current Directory: %cd%
echo.
echo Made by Nexint, 2023.
echo.
pause

cls
echo list disk> test2.bat
diskpart /s test1.bat
del test1.bat
goto diskverify

:diskverify
set /p choice=Disk Number?
set varCheck=%choice%
IF 1%varCheck% NEQ +1%varCheck% (goto errordisk) else (goto continuedisk) 

:errordisk
echo Not a number!
pause
goto diskverify

:continuedisk
set curdisk="%choice%"
echo select disk "%choice%" >> test2.bat
echo clean>> test2.bat
echo conv gpt>> test2.bat
echo cre par efi size=1000>> test2.bat
echo format fs=fat32>> test2.bat
goto efiverify

:efiverify
set /p choice=Letter of EFI Partition?
echo %choice%|findstr "^[A-Za-z]*$" >nul
if %errorlevel% == 0 (goto checkefi) else (goto errorefi)

:checkefi
ECHO %choice%> tempfile.txt
FOR %%? IN (tempfile.txt) DO ( SET /A strlength=%%~z? - 2 )
del tempfile.txt
if %strlength%==1 (goto continueefi) else (goto errorefi)

:errorefi
echo Not a letter!
pause
goto efiverify

:continueefi
set efipar="%choice%"
echo ass letter="%choice%">> test2.bat
echo cre par pri>> test2.bat
echo format fs=ntfs quick>> test2.bat
goto mainverify

:mainverify
set /p choice=Letter of Main Partition?
echo %choice%|findstr "^[A-Za-z]*$" >nul
if %errorlevel% == 0 (goto checkmain) else (goto errormain)

:checkmain
ECHO %choice%> tempfile.txt
FOR %%? IN (tempfile.txt) DO ( SET /A strlength=%%~z? - 2 )
del tempfile.txt
if %strlength%==1 (goto continuemain) else (goto errormain)

:errormain
echo Not a letter!
pause
goto mainverify

:continuemain
set bootpar="%choice%"
echo ass letter="%choice%">> test2.bat
echo exit>> test2.bat

SET /P oobevar=Skip OOBE? (W10/11 ONLY) (Y/[N])?
IF /I "%oobevar%" NEQ "Y" GOTO isochoose
SET /P appinstall=Install Apps? (W10/11 ONLY) (Y/[N])?
SET /P ooberestore=Restore? (W10/11 ONLY) (Y/[N])?
goto isochoose

:isochoose
cls
echo To confirm, your mount folders are:
echo %efipar%
echo %bootpar%
set /p choice="Pick your ISO! (1, 2, 3, 4), 1=Win 7, 2=Win 8.1, 3= Win10, 4= Win11"
if %choice% ==4 goto four
if %choice% ==3 goto three
if %choice% ==2 goto two
if %choice% ==1 goto one
echo Invalid choice.
pause
cls
goto isochoose

:four
dism /get-imageinfo /imagefile:%cd%\Win11\sources\install.wim
set /p choice=Type the install index you wish to use.
set varCheck=%choice%
IF 1%varCheck% NEQ +1%varCheck% (goto errordismfour) else (goto continuedismfour) 

:errordismfour
echo Invalid choice!
pause
cls
goto four

:continuedismfour
SET /P AREYOUSURE=Are you sure? This WILL erase disk %curdisk% (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
cls
echo Stage 1!
diskpart /s test2.bat
del test2.bat
cls
echo Stage 2!
dism /apply-image /imagefile:%cd%\Win11\sources\install.wim /index:"%choice%" /applydir:%bootpar%:\
goto bcdboot

:three
dism /get-imageinfo /imagefile:%cd%\Win10\sources\install.wim
set /p choice=Type the install index you wish to use.
set varCheck=%choice%
IF 1%varCheck% NEQ +1%varCheck% (goto errordismthree) else (goto continuedismthree) 

:errordismthree
echo Invalid choice!
pause
cls
goto three

:continuedismthree
SET /P AREYOUSURE=Are you sure? This WILL erase disk %curdisk% (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
cls
echo Stage 1!
diskpart /s test2.bat
del test2.bat
cls
echo Stage 2! (Mounting / Modifying, Language changing to EN_INTERNATIONAL)
del %cd%\Temp\install.wim
xcopy %cd%\Win10\sources\install.wim %cd%\Temp /v
mkdir %bootpar%:\Temp
dism /Mount-image /imagefile:%cd%\Temp\Install.wim /index:"%choice%" /MountDir:%bootpar%:\Temp
dism /Image:"%bootpar%:\Temp" /Add-Package /PackagePath="%cd%\LangPacks\W1022h2\EN_GB.cab"
dism /image:%bootpar%:\Temp /Set-AllIntl:en-GB
dism /Unmount-Image /mountdir:%bootpar%:\Temp /commit /checkintegrity
echo Please close all explorer window instances!
pause
dism /unmount-image /mountdir:%bootpar%:\Temp /discard
echo If this command failed, restart your PC.
pause
rmdir %bootpar%:\Temp
dism /apply-image /imagefile:%cd%\Temp\install.wim /index:"%choice%" /applydir:%bootpar%:\
del %cd%Temp\install.wim
goto bcdboot

:two
dism /get-imageinfo /imagefile:%cd%\Win8dot1\sources\install.wim
set /p choice=Type the install index you wish to use.
set varCheck=%choice%
IF 1%varCheck% NEQ +1%varCheck% (goto errordismtwo) else (goto continuedismtwo) 

:errordismtwo
echo Invalid choice!
pause
cls
goto two

:continuedismtwo
SET /P AREYOUSURE=Are you sure? This WILL erase disk %curdisk% (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
cls
echo Stage 1!
diskpart /s test2.bat
del test2.bat
cls
echo Stage 2!
dism /apply-image /imagefile:%cd%\Win8dot1\sources\install.wim /index:"%choice%" /applydir:%bootpar%:\
goto bcdboot

:one
dism /get-imageinfo /imagefile:%cd%\Win7\sources\install.wim
set /p choice=Type the install index you wish to use.
set varCheck=%choice%
IF 1%varCheck% NEQ +1%varCheck% (goto errordismone) else (goto continuedismone) 

:errordismone
echo Invalid choice!
pause
cls
goto one

:continuedismone
SET /P AREYOUSURE=Are you sure? This WILL erase disk %curdisk% (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
cls
echo Stage 1!
diskpart /s test2.bat
del test2.bat
cls
echo Stage 2!
dism /apply-image /imagefile:%cd%\Win7\sources\install.wim /index:"%choice%" /applydir:%bootpar%:\
goto bcdboot

:bcdboot
cls Stage 3! (Making Boot Files)
bcdboot %bootpar%:\windows /s %efipar%:\
goto oobe

:oobe
IF /I "%oobevar%" NEQ "Y" GOTO exitmsg
cls
echo Stage 4! (Bypass OOBE / Restore Apps / Backup Files)
reg unload "HKLM\SYS" >nul 2>&1
reg unload "HKLM\soft" >nul 2>&1
reg load "HKLM\SYS" "%bootpar%:\windows\system32\config\system"
reg add "HKLM\SYS\Setup" /v CmdLine /t REG_SZ /d OOBE.bat /f
cd /d %userprofile%
mkdir %bootpar%:\RestoreBackup
cd /d %var%
echo %cd%
if /I "%appinstall%" NEQ "Y" GOTO continuerestore
robocopy "Applications" "%bootpar%:\RestoreBackup\Applications"  /e /v /eta /bytes /r:5 /w:1 /zb /j
:continuerestore
cd /d %userprofile%
xcopy "OOBE.bat" "%bootpar%:\Windows\System32" /v
reg load "HKLM\soft" "%bootpar%:\windows\system32\config\software"
if /i "%ooberestore%" NEQ "Y" goto skipoobe
robocopy "Downloads" "%bootpar%:\RestoreBackup\Downloads"  /e /v /eta /bytes /r:5 /w:1 /zb /j
robocopy "Videos" "%bootpar%:\RestoreBackup\Videos" /e /v /eta /bytes /r:5 /w:1 /zb /j
robocopy "Pictures" "%bootpar%:\RestoreBackup\Pictures" /e /v /eta /bytes /r:5 /w:1 /zb /j
robocopy "Documents" "%bootpar%:\RestoreBackup\Documents" /e /v /eta /bytes /r:5 /w:1 /zb /j
robocopy "Desktop" "%bootpar%:\RestoreBackup\Desktop" /e /v /eta /bytes /r:5 /w:1 /zb /j
robocopy "Music" "%bootpar%:\RestoreBackup\Music" /e /v /eta /bytes /r:5 /w:1 /zb /j
:skipoobe
xcopy "RestoreBackup.vbs" "%bootpar%:\RestoreBackup" /v
xcopy "PostInstall.bat" "%bootpar%:\RestoreBackup" /v
cd /d %var%
xcopy "RestoreBackup.bat" "%bootpar%:\RestoreBackup" /v
reg add "HKLM\soft\Microsoft\Windows\CurrentVersion\Run" /v PostInstall /t REG_SZ /d "cmd /c "C:\RestoreBackup\PostInstall.bat"" /f
reg add "HKLM\soft\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1 /f
reg unload "HKLM\SYS"
reg unload "HKLM\soft"
goto exitmsg

:exitmsg
cd /d %userprofile%
del "OOBE.bat"
del "RestoreBackup.vbs"
del "PostInstall.bat"
echo.
echo Made by Nexint / Tency, 2023.
echo.
echo Done! Restart your PC. Windows 7 / 8.1 may behave unexpectactly with OOBE SKIP.
pause
goto END

:abort
echo Program aborted / An error occured. (Error code: %errorlevel%)
pause
goto END

:END
endlocal