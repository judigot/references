@echo off
set HOME=%USERPROFILE%
set "HOME=%HOME:\=/%"
set "HOME=%HOME:C:=/mnt/c%"

set BASH_ENV=%USERPROFILE%\.bashrc
set "BASH_ENV=%BASH_ENV:\=/%"
set "BASH_ENV=%BASH_ENV:C:=/mnt/c%"

setlocal enabledelayedexpansion

set PATHEXT=%PATHEXT%;.EXE

for /f "usebackq tokens=2,* delims=    " %%i in (`reg query "HKCU\Volatile Environment" /v HOMEDRIVE ^&^& reg query "HKCU\Volatile Environment" /v HOMEPATH`) do (
    set "HOMEDRIVE=%%i"
    set "HOMEPATH=%%j"
)
set "USER_HOME=%HOMEDRIVE%%HOMEPATH%"

set "pathsLinux="
for /f "delims=" %%i in ('curl -s https://raw.githubusercontent.com/judigot/references/main/PATH') do (
    set "path=%%i"
    set "path=!path:\=/!"
    set "path=!path:C:=/mnt/c!"
    set "path=!path:$HOME=%USER_HOME%!"
    set "path=!path:%USER_HOME%=/mnt/c/Users/%USERNAME%!"
    if "!path: =!" neq "!path!" set "path="!path!""
    set "pathsLinux=!pathsLinux!!path!:"
)

set "UBUNTU_EXE=%USER_HOME%\AppData\Local\Microsoft\WindowsApps\ubuntu.exe"

if "%~1"=="" (
    %UBUNTU_EXE% run "export HOME=%HOME% && export BASH_ENV=%BASH_ENV% && export PATH=\"$PATH:%pathsLinux%\" && exec bash"
) else (
    cd /d %~dp1
    set "input_path=%~1"
    set "input_path=!input_path:\=/!"
    set "input_path=!input_path:C:=/mnt/c!"
    %UBUNTU_EXE% run "export HOME=%HOME% && export BASH_ENV=%BASH_ENV% && export PATH=\"$PATH:%pathsLinux%\" && bash '!input_path!'"
)
endlocal
