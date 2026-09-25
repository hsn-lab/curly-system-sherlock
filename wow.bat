@echo off
setlocal EnableExtensions DisableDelayedExpansion
title System Sherlock - Authorized Windows Diagnostics

rem Read-only inventory and diagnostics. This script never changes permissions,
rem bypasses access controls, elevates itself, or collects credentials.
set "MODE=quick"
set "NETWORK=0"
set "OUTDIR=%~dp0reports"
set "OUT="

:args
if /i "%~1"=="/full" set "MODE=full" & shift & goto args
if /i "%~1"=="/network" set "NETWORK=1" & shift & goto args
if /i "%~1"=="/quiet" set "QUIET=1" & shift & goto args
if /i "%~1"=="/out" if not "%~2"=="" set "OUT=%~2" & shift & shift & goto args
if not "%~1"=="" if /i not "%~1"=="/?" if /i not "%~1"=="/help" echo Unknown option: %~1

if not defined OUT (
  if not exist "%OUTDIR%" mkdir "%OUTDIR%" >nul 2>&1
  for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"`) do set "OUT=%OUTDIR%\system-sherlock-%%T.txt"
)
if not defined OUT set "OUT=%TEMP%\system-sherlock.txt"

if /i "%~1"=="/?" goto help
if /i "%~1"=="/help" goto help

>"%OUT%" echo System Sherlock - Read-only Windows diagnostic report
>>"%OUT%" echo Generated: %DATE% %TIME%
>>"%OUT%" echo Computer: %COMPUTERNAME%
>>"%OUT%" echo Mode: %MODE%  Network diagnostics: %NETWORK%
>>"%OUT%" echo.

call :section "ACCESS CONTEXT"
call :run "whoami /all"
call :run "fltmc"
>>"%OUT%" echo Note: Access denied output is recorded as a finding; no attempt is made to circumvent it.

call :section "OPERATING SYSTEM"
call :run "systeminfo"
call :run "ver"

call :section "HARDWARE AND STORAGE"
call :ps "Get-CimInstance Win32_Processor ^| Select-Object Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed ^| Format-List"
call :ps "Get-CimInstance Win32_ComputerSystem ^| Select-Object Manufacturer,Model,TotalPhysicalMemory,SystemType ^| Format-List"
call :ps "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' ^| Select-Object DeviceID,FileSystem,Size,FreeSpace ^| Format-Table -AutoSize"
call :ps "Get-CimInstance Win32_DiskDrive ^| Select-Object Model,InterfaceType,Size,Status ^| Format-Table -AutoSize"

call :section "NETWORK CONFIGURATION"
call :run "ipconfig /all"
call :run "getmac /v"
call :run "netsh wlan show interfaces"
if "%NETWORK%"=="1" (
  call :section "NETWORK DIAGNOSTICS (OPT-IN)"
  call :run "nslookup example.com"
  call :run "ping -n 3 127.0.0.1"
  call :run "tracert -h 5 example.com"
  call :run "netstat -ano"
  call :run "route print"
  call :run "arp -a"
)

call :section "PROCESSES AND SERVICES"
call :run "tasklist /fo table"
if /i "%MODE%"=="full" (
  call :run "tasklist /v"
  call :run "sc query"
)

call :section "USER AND SHARED-RESOURCE INVENTORY"
call :run "echo Current user: & whoami"
call :run "net user"
call :run "net share"
call :run "query session"

call :section "EVENTS AND SECURITY POSTURE"
call :ps "Get-MpComputerStatus ^| Select-Object AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled ^| Format-List"
call :ps "Get-BitLockerVolume ^| Select-Object MountPoint,VolumeStatus,ProtectionStatus,EncryptionMethod ^| Format-Table -AutoSize"
call :ps "Get-WinEvent -ListLog * -ErrorAction SilentlyContinue ^| Where-Object {$_.IsEnabled} ^| Select-Object -First 30 LogName,RecordCount,FileSize ^| Format-Table -AutoSize"

call :section "POWER AND ENVIRONMENT (NON-SENSITIVE)"
call :run "powercfg /getactivescheme"
call :ps "Get-ChildItem Env: ^| Where-Object Name -match '^(OS|PROCESSOR_|NUMBER_OF_|COMSPEC|SYSTEMROOT|TEMP|TMP|USERNAME)$' ^| Sort-Object Name ^| Format-Table -AutoSize"

>>"%OUT%" echo.
>>"%OUT%" echo Completed. This report may contain usernames, hostnames, IP addresses, process names, and event metadata.
>>"%OUT%" echo Review and redact before sharing.
if not defined QUIET type "%OUT%"
echo Report saved to: "%OUT%"
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
cmd /d /c "%~1" >>"%OUT%" 2>&1
exit /b 0

:ps
>>"%OUT%" echo.
>>"%OUT%" echo [POWERSHELL] %~1
>>"%OUT%" echo ------------------------------------------------------------
powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "%~1" >>"%OUT%" 2>&1
exit /b 0

:help
echo Usage: wow.bat [/quick^|/full] [/network] [/quiet] [/out FILE]
echo.
echo /quick    Collect a concise read-only inventory (default).
echo /full     Include verbose processes and services.
echo /network  Opt in to DNS, ping, traceroute, sockets, routes, and ARP checks.
echo /quiet    Do not print the report; still writes it to disk.
echo /out FILE Write to a specific report path.
echo.
echo This tool does not bypass permissions, elevate privileges, alter accounts,
echo access files, or retrieve credentials. Run it only on systems you own or are
 echo authorized to assess. Missing permissions are reported safely.
pause
exit /b 0
