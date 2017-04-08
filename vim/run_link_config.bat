@ECHO off
::------------------------------------------------------------------- windows ::
:: Simple script to link .vimrc for VIM
::----------------------------------------------------------------------------::
SET NAME_SCRIPT=%~n0
SET PATH_SCRIPT_DIR=%~dp0
SET PATH_SCRIPT_DIR=%PATH_SCRIPT_DIR:~0,-1%

::----------------------------------------------------------------------------::
ECHO %NAME_SCRIPT%: making links

IF exist "%userprofile%\.vimrc" DEL "%userprofile%\.vimrc"
mklink "%userprofile%\.vimrc" "%PATH_SCRIPT_DIR%\nix.vimrc" || GOTO :err

::----------------------------------------------------------------------------::
GOTO :eof

:err
ECHO %NAME_SCRIPT%: exiting with error '%errorlevel%'
EXIT /b %errorlevel%

:eof
