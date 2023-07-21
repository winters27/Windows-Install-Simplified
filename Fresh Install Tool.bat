@echo off
mode con: cols=100 lines=30
setlocal enabledelayedexpansion


echo.
echo.
echo.
echo             /$$$$$$            /$$                              /$$                
echo            /$$__  $$          ^|__/                             ^| $$                
echo           ^| $$  \__/  /$$$$$$  /$$  /$$$$$$  /$$$$$$   /$$$$$$$^| $$$$$$$   /$$$$$$ 
echo           ^|  $$$$$$  /$$__  $$^| $$ /$$__  $$^|____  $$ /$$_____/^| $$__  $$ ^|____  $$
echo            \____  $$^| $$  \__/^| $$^| $$  \__/ /$$$$$$$^| $$      ^| $$  \ $$  /$$$$$$$
echo            /$$  \ $$^| $$      ^| $$^| $$      /$$__  $$^| $$      ^| $$  ^| $$ /$$__  $$
echo           ^|  $$$$$$/^| $$      ^| $$^| $$     ^|  $$$$$$$^|  $$$$$$$^| $$  ^| $$^|  $$$$$$$
echo            \______/ ^|__/      ^|__/^|__/      \_______/ \_______/^|__/  ^|__/ \_______/
echo.
echo.
echo.
echo                              /$$$$$$$$                  /$$                        
echo                             ^|__  $$__/                 ^| $$                        
echo                                ^| $$  /$$$$$$   /$$$$$$ ^| $$                        
echo                                ^| $$ /$$__  $$ /$$__  $$^| $$                        
echo                                ^| $$^| $$  \ $$^| $$  \ $$^| $$                        
echo                                ^| $$^| $$  ^| $$^| $$  ^| $$^| $$                        
echo                                ^| $$^|  $$$$$$/^|  $$$$$$/^| $$                        
echo                                ^|__/ \______/  \______/ ^|__/                        
echo.
echo.
echo.
echo                                         by [94mWinters[0m
echo.
echo.
echo.
pause
echo.



REM Check if the script is running with admin privileges
>nul 2>&1 "%SYSTEMROOT%\system32\icacls.exe" "%SYSTEMROOT%\system32\config\system"
if "%errorlevel%" NEQ "0" (
    echo ERROR: This script requires administrator privileges.
    echo Please run the script as an administrator.
    pause
    exit /b
)

REM The script is running with admin privileges. Continue with the script.

REM Check if Chocolatey is already installed using PowerShell
powershell -command "& {if (Get-Command choco -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }}"
if %errorlevel% equ 1 (
    echo Installing Chocolatey...
    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
) else (
    echo [33mChocolatey[0m is already installed.
    echo.
    pause
)

REM Prompt user to add or remove programs from the list


echo.
echo.
echo [96mThe following programs will be installed using[0m [33mChocolatey[0m[96m:[0m
echo.

REM Original program list
set "originalList=googlechrome discord bitwarden steam geforce-experience amd-ryzen-master equalizerapo 7zip f.lux qbittorrent vscode joytokey revo-uninstaller"

REM Display original list
for %%P in (%originalList%) do (
    echo %%P
    powershell -command "Start-Sleep -Milliseconds 250" > nul
)

echo.

REM Delay to give a chance for the previous pause to complete
timeout /t 1 > nul

REM Initialize the program list variable
set "programList=%originalList%"
set "addedPrograms="



:ChooseAction
REM Use the choice command for user input
echo.
echo:           ______________________________________________________________
echo.
echo                                [1] Add programs
echo                                [2] Remove programs
echo                                [3] Finish and install programs
echo                                [4] Cancel installation
echo.           ______________________________________________________________
echo.
echo.
set /p "action=[96mEnter the number of the action you want to perform:[0m "

if "%action%"=="1" (
    set "programsToAddInput="
    echo.
    set /p "programsToAddInput=[96mEnter the additional programs you want to install (space-separated):[0m "
    REM Update the program list after addition
    set "programsToAdd=!programsToAddInput!"
    for %%P in (!programsToAddInput!) do (
        call :AddProgram "%%P"
    )
    echo.
    cls
    goto :ChooseAction
) else if "%action%"=="2" (
    set "programsToRemoveInput="
    echo.
    set /p "programsToRemoveInput=[96mEnter the programs you want to remove from the list (space-separated):[0m "
    REM Update the program list after removal
    set "programsToRemove=!programsToRemoveInput!"
    for %%P in (!programsToRemoveInput!) do (
        call :RemoveProgram "%%P"
    )
    echo.
    cls
    goto :ChooseAction
) else if "%action%"=="3" (
    REM No input or 'done' is entered; proceed to verify the program list and install missing programs.
    echo.
    cls
    goto :VerifyList
) else if "%action%"=="4" (
    echo.
    cls
    echo Installation cancelled by the user.
    goto :SkipInstallation
) else (
    REM Invalid input; ask again.
    echo.
    echo Invalid input. Please try again.
    echo.
    goto :ChooseAction
)

:AddProgram
echo !programList! | find /i "%~1" > nul
if errorlevel 1 (
    set "programList=!programList! %~1"
    echo Program %~1 added to the list.
) else (
    echo Program %~1 is already in the list. Skipping addition.
)
exit /b

:RemoveProgram
for %%P in (%programList%) do (
    if /I "%%P"=="%~1" (
        set "programList=!programList:%%P=!"
        echo Program %~1 removed from the list.
        exit /b
    )
)
echo Program %~1 is not in the list. Skipping removal.
exit /b

:VerifyList
REM Display the updated program list for verification
echo.
echo The updated list of programs to be installed or checked:
echo.

REM Display the updated list with added programs in green
set "isAdded=0"
for %%P in (%programList%) do (
    echo %%P | findstr /i "\<%%P\> %addedPrograms%" > nul
    if errorlevel 1 (
        echo %%P
    ) else (
        echo [92m%%P[0m
        REM Set the isAdded flag to indicate an added program exists in the list
        set "isAdded=1"
    )
    powershell -command "Start-Sleep -Milliseconds 250" > nul
)

REM If no added programs, set isAdded flag to 0
if not defined isAdded set "isAdded=0"

REM Display the removed programs in red
for %%P in (%removedPrograms%) do (
    echo [91m%%P[0m
    powershell -command "Start-Sleep -Milliseconds 250" > nul
)

echo.

REM Ask for user verification before proceeding
if %isAdded% equ 0 (
    echo [92mNo programs added to the list.[0m
)

set /p "proceed=[96mDo you want to proceed with the installation?[0m (Y/N): "
if /i "%proceed%"=="y" (
    REM Proceed with installation
) else if /i "%proceed%"=="n" (
    echo.
    echo [101mInstallation cancelled by the user.[0m
    goto :SkipInstallation
) else (
    REM Invalid input; ask again.
    echo.
    echo Invalid input. Please enter 'yes' or 'no'.
    echo.
    goto :ChooseAction
)




REM Check installed programs before potential changes
echo.
echo Checking installed programs before changes...
for %%P in (%programList%) do (
    where /q %%P
    if %errorlevel% equ 0 (
        echo Program %%P is already installed. Skipping installation.
    ) else (
        echo Installing %%P...
        choco install %%P -y >NUL
        if %errorlevel% equ 0 (
            echo Program %%P is installed successfully.
        ) else (
            echo Failed to install %%P or it is already installed.
        )
    )
)
echo.


:SkipInstallation
REM Continue with Windows activation and bloatware removal
echo.
echo Skipping to Windows activation and bloatware removal tools...
echo.

goto :ActivationAndBloatware

:ActivationAndBloatware
REM Prompt the user if they want to continue with Windows activation or exit the script
set /p "continueActivation=[96mDo you want to continue with Windows activation?[0m (Y/N): "
if /i "%continueActivation%"=="y" (
    echo.
    echo Activating Windows...
    powershell -Command "irm https://massgrave.dev/get|iex"
) else if /i "%continueActivation%"=="n" (
    echo.
    echo [101mSkipping Windows activation.[0m
) else (
    REM Invalid input; ask again.
    echo.
    echo Invalid input. Please enter 'yes' or 'no'.
    echo.
    goto :ActivationAndBloatware
)

:BloatwareRemoval
REM Prompt the user if they want to continue with bloatware removal or exit the script
echo.
set /p "continueBloatwareRemoval=[96mDo you want to continue with bloatware removal?[0m (Y/N): "
if /i "%continueBloatwareRemoval%"=="y" (
    echo.
    echo Removing bloatware...
    powershell -Command "iwr -useb https://git.io/debloat|iex"
) else if /i "%continueBloatwareRemoval%"=="n" (
    echo.
    echo [101mSkipping bloatware removal.[0m
) else (
    REM Invalid input; ask again.
    echo.
    echo Invalid input. Please enter 'yes' or 'no'.
    echo.
    goto :BloatwareRemoval
)
echo.
echo Script execution complete!
echo.
pause

