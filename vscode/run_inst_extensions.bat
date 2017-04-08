@ECHO off
::------------------------------------------------------------------- windows ::
:: Simple script to install visual studio code extensions
::----------------------------------------------------------------------------::
SET NAME_SCRIPT=%~n0
SET PATH_SCRIPT_DIR=%~dp0
SET PATH_SCRIPT_DIR=%PATH_SCRIPT_DIR:~0,-1%

::----------------------------------------------------------------------------::
ECHO %NAME_SCRIPT%: installing extensions

FOR /F "eol=#" %%L in (%PATH_SCRIPT_DIR%\cmn_extensions.txt) do (
	call "C:\Program Files (x86)\Microsoft VS Code\bin\code.cmd" --install-extension %%L || GOTO :err
)

::----------------------------------------------------------------------------::
GOTO :eof

:err
ECHO %NAME_SCRIPT%: exiting with error '%errorlevel%'
EXIT /b %errorlevel%

:eof
