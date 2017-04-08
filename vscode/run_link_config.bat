@ECHO off
::------------------------------------------------------------------- windows ::
:: Simple script to link  visual studio code settings and key bindings
::----------------------------------------------------------------------------::
SET NAME_SCRIPT=%~n0
SET PATH_SCRIPT_DIR=%~dp0
SET PATH_SCRIPT_DIR=%PATH_SCRIPT_DIR:~0,-1%

::----------------------------------------------------------------------------::
ECHO %NAME_SCRIPT%: making links

IF exist %APPDATA%\code\user\settings.json DEL %APPDATA%\code\user\settings.json
mklink %APPDATA%\code\user\settings.json %PATH_SCRIPT_DIR%\cmn_settings.json || GOTO :err

::----------------------------------------------------------------------------::
GOTO :eof

:err
ECHO %NAME_SCRIPT%: exiting with error '%errorlevel%'
EXIT /b %errorlevel%

:eof
