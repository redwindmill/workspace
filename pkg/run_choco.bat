@ECHO off
::------------------------------------------------------------------- windows ::
:: Script that will update and install homebrew packages on osx.
:: NOTE: You will need chocolatey first
:: NOTE: Install visual studio manually
::
:: @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
::----------------------------------------------------------------------------::
SET NAME_SCRIPT=%~n0

::core packages
SET PACKAGES=^
7zip ^
ccleaner ^
cmake ^
git ^
golang ^
lua ^
notepad2 ^
procexp ^
python2 ^
visualstudiocode

::workstation packages
IF "%1" == "workstation" (

SET PACKAGES=%PACKAGES% ^
docker ^
docker-compose ^
docker-machine ^
gimp ^
googlechrome ^
googledrive ^
putty ^
sysinternals ^
winscp

)

::----------------------------------------------------------------------------::
ECHO %NAME_SCRIPT%: upgrading chocolatey
choco upgrade all || GOTO :err

ECHO %NAME_SCRIPT%: installing packages
FOR %%P in (%PACKAGES%) DO (
	choco install %%P || GOTO :err
)

::----------------------------------------------------------------------------::
GOTO :eof

:err
ECHO %NAME_SCRIPT%: exiting with error '%errorlevel%'
EXIT /b %errorlevel%

:eof
