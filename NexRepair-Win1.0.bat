@echo off
:: Check privileges 
net file 1>NUL 2>NUL
if not '%errorlevel%' == '0' (
    powershell Start-Process -FilePath "%0" -ArgumentList "%cd%, /e:on" -verb runas >NUL 2>&1
    exit /b
)

:: Change directory with passed argument. Processes started with
:: "runas" start with forced C:\Windows\System32 workdir
cd /d %1
if "%nexchoice%"=="" set nexchoice=0
if "%nexmanual%"=="" set nexmanual=0
goto start

:start
if %nexmanual%==1 goto manual
if %nexchoice%==1 goto autodism
if %nexchoice%==2 goto autoclean
cls
echo Welcome to Nexint's Windows Repair!
echo Version 1.00
echo Please report any bugs to our Github!
echo.
echo What do you want to do?
echo 1: Repair with step by step process (Recommended)
echo 2: Automatic Repair (With Restarts)
echo 3: Automatic Repair (Without Restarts)
echo 4: WinPE Repair (Auto) (Under Construction)
echo 5: Exit
echo.
echo Dev Info:
echo File Name: %~nx0
echo Current Directory: %cd%
echo File Name + Directory: %~f0
choice /c 12345
if %errorlevel%==1 goto ynmanual
if %errorlevel%==2 goto ynauto
if %errorlevel%==3 goto ynautonr
if %errorlevel%==4 goto ynautope
if %errorlevel%==5 goto exit
goto start

:manual
if %nexchoice%==1 goto drivers
if %nexchoice%==2 goto dism

:ynmanual
cls
echo Are you sure? We will start the repair process here.
choice /c yn
if %errorlevel%==1 goto sfc
if %errorlevel%==2 goto start

:sfc
echo Were going to try scanning your system with sfc /scannow.
pause
sfc /scannow
schtasks /create /sc onlogon /tn NexRepair /tr %cd%\%~nx0 /rl HIGHEST /f
setx nexchoice 1
setx nexmanual 1
echo Would you like to restart?
choice /c yn
if %errorlevel%==1 goto restart
if %errorlevel%==2 goto drivers

:manualexit
cls
echo Cleaning up residue files / entries...
setx nexchoice ""
setx nexmanual ""
schtasks /delete /tn NexRepair /f
echo Glad to see that the problem has been resolved! See you next time.
pause
goto exit

:restart
cls
echo Restarting! Save your current programs / applications first.
echo Restart by pressing any key.
pause
shutdown /s -t 1
exit

:drivers
echo Has your problem been fixed yet?
choice /c yn
if %errorlevel%==1 goto manualexit
if %errorlevel%==2 goto getdriver

:getdriver
cls
echo Let's see your system components...
echo Your CPU is:
wmic cpu get name
echo Your GPU is:
wmic path win32_VideoController get name
echo Search for these system drivers on Google and download the official drivers!
echo Install these, manually restart and see if the problem has been solved.
setx nexchoice 2
pause
goto :getdriver

:dism
echo Has your problem been solved?
choice /c yn
if %errorlevel%==1 goto manualexit
echo We are now going to scan the Windows image for errors and fix any outstanding errors.
DISM /Online /Cleanup-Image /RestoreHealth
setx nexchoice 3
echo Would you like to restart?
choice /c yn
if %errorlevel%==2 goto clean
if %errorlevel%==1 goto restart

:clean
cls
echo Cleaning up residue files / entries...
setx nexchoice ""
setx nexmanual ""
schtasks /delete /tn NexRepair /f
echo Done!
echo If the problem still persists, you may have to reinstall Windows.
pause
goto exit

:ynauto
cls
echo Are you sure? This WILL restart your computer multiple times.
choice /c yn
if %errorlevel%==1 goto autosfc
if %errorlevel%==2 goto start

:autosfc
cls
echo Scanning using SFC /scannow...
echo Save any currently running programs! This will automatically restart your PC.
sfc /scannow
schtasks /create /sc onlogon /tn NexRepair /tr %cd%\%~nx0 /rl HIGHEST /f
setx nexchoice 1
setx nexmanual 0
echo Restarting...
shutdown /r -t 30
pause
exit

:autodism
echo Using DISM to clean up the image...
DISM /Online /Cleanup-Image /RestoreHealth
setx nexchoice 2
echo Restarting…
shutdown /r -t 30
pause
exit

:autoclean
echo Cleaning up files...
setx nexchoice ""
setx nexmanual ""
schtasks /delete /tn NexRepair /f
echo Done!
echo If the problem still persists, you may have to reinstall Windows.
pause
goto exit

:ynautonr
cls
echo Are you sure? This option is mostly for debugging.
choice /c yn
if %errorlevel%==1 goto nrautosfc
if %errorlevel%==2 goto start

:nrautosfc
cls
echo Scanning using SFC /scannow...
sfc /scannow
goto nrautodism

:nrautodism
echo Using DISM to clean up the image...
DISM /Online /Cleanup-Image /RestoreHealth
goto nrautoclean

:nrautoclean
cls
echo Done!
echo If the problem still persists, you may have to reinstall windows.
pause
goto exit

:ynautope
echo This is currently under construction.
pause
goto exit

:exit
exit /b