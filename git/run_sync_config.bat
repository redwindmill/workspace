@ECHO off
::------------------------------------------------------------------- windows ::
:: Simple script to generate a .gitconfig file
::----------------------------------------------------------------------------::
SET NAME_SCRIPT=%~n0
SET PATH_SCRIPT_DIR=%~dp0
SET PATH_SCRIPT_DIR=%PATH_SCRIPT_DIR:~0,-1%

IF [%1] == [] GOTO :invalid
IF [%2] == [] GOTO :invalid
IF NOT [%3] == [] GOTO :invalid

::----------------------------------------------------------------------------::
ECHO %NAME_SCRIPT%: generating config

SET GIT_FULLNAME="%1"
SET GIT_FULLNAME=%GIT_FULLNAME:"=%

SET GIT_EMAIL="%2"
SET GIT_EMAIL=%GIT_EMAIL:"=%

IF exist %userprofile%\.gitconfig DEL %userprofile%\.gitconfig
SET PS_COMMAND="(Get-Content '%PATH_SCRIPT_DIR%\win.gitconfig') -replace '\$\{GIT_FULLNAME\}', '%GIT_FULLNAME%' -replace '\$\{GIT_EMAIL\}', '%GIT_EMAIL%' | Set-Content -Path '%userprofile%\.gitconfig' -Encoding Ascii"
powershell -Command %PS_COMMAND% || GOTO :err

::----------------------------------------------------------------------------::
GOTO :eof

:invalid
ECHO "%NAME_SCRIPT%: arguments are <full-name> <email>"
EXIT /b 1

:err
ECHO "%NAME_SCRIPT%: exiting with error '%errorlevel%'"
EXIT /b %errorlevel%

:eof
