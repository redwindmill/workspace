@ECHO off
::------------------------------------------------------------------- windows ::
:: Simple script to link .bash_profile for MINGW
::----------------------------------------------------------------------------::
SET NAME_SCRIPT=%~n0
SET PATH_SCRIPT_DIR=%~dp0
SET PATH_SCRIPT_DIR=%PATH_SCRIPT_DIR:~0,-1%

::----------------------------------------------------------------------------::
ECHO %NAME_SCRIPT%: making links

IF exist "%userprofile%\.bash_profile" DEL "%userprofile%\.bash_profile"
mklink "%userprofile%\.bash_profile" "%PATH_SCRIPT_DIR%\nix.bash_profile" || GOTO :err

IF exist "%userprofile%\.bashrc" DEL "%userprofile%\.bashrc"
mklink "%userprofile%\.bashrc" "%PATH_SCRIPT_DIR%\nix.bash_profile" || GOTO :err

IF NOT exist "%SYSTEMDRIVE%\bin" mkdir "%SYSTEMDRIVE%\bin"
ECHO @ECHO off > %SYSTEMDRIVE%\bin\gbash.bat || GOTO :err
ECHO "%PROGRAMFILES%\Git\bin\bash.exe" --login %%* >> %SYSTEMDRIVE%\bin\gbash.bat || GOTO :err

IF NOT exist "%userprofile%\.bashrc.local" COPY NUL "%userprofile%\.bashrc.local"

::----------------------------------------------------------------------------::
GOTO :eof

:err
ECHO %NAME_SCRIPT%: exiting with error '%errorlevel%'
EXIT /b %errorlevel%

:eof
