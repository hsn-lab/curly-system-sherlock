@echo off
setlocal EnableExtensions DisableDelayedExpansion
 title System Sherlock - Simple Windows Diagnostics

rem Simple, read-only checks. No administrator rights are required.
set "OUT=%TEMP%\system-sherlock.txt"

>"%OUT%" echo System Sherlock - Read-only Windows diagnostic report
>>"%OUT%" echo Generated: %DATE% %TIME%
>>"%OUT%" echo Computer: %COMPUTERNAME%
>>"%OUT%" echo User: %USERNAME%
>>"%OUT%" echo.

call :section "WINDOWS"
call :run "ver"
call :run "whoami"
call :run "systeminfo"

call :section "HARDWARE"
call :run "wmic cpu get name,NumberOfCores,NumberOfLogicalProcessors"
call :run "wmic computersystem get manufacturer,model,totalphysicalmemory"
call :run "wmic logicaldisk get deviceid,size,freespace"

call :section "NETWORK"
call :run "ipconfig /all"
call :run "getmac"

call :section "PROCESSES"
call :run "tasklist"

call :section "ENVIRONMENT"
call :run "set"

>>"%OUT%" echo.
>>"%OUT%" echo Completed. Some commands may show Access is denied or may not be available.
>>"%OUT%" echo This report can contain usernames, computer names, IP addresses, and process names.

echo Report saved to:
echo %OUT%
echo.
echo Opening the report...
start "" notepad.exe "%OUT%"
echo.
pause
exit /b 0

:section
>>"%OUT%" echo.
>>"%OUT%" echo ============================================================
>>"%OUT%" echo %~1
>>"%OUT%" echo ============================================================
exit /b 0

:run
>>"%OUT%" echo.
>>"%OUT%" echo [COMMAND] %~1
>>"%OUT%" echo ------------------------------------------------------------
cmd.exe /d /c "%~1" >>"%OUT%" 2>&1
exit /b 0
