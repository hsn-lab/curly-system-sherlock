@ECHO OFF
echo %DATE%
CLS
DIR

DRIVERQUERY

echo %DATE%
IPCONFIG/ALL
ASSOC | find ".txt"
CHKDSK

:: This batch file details Windows 10, hardware, and networking configuration.

TITLE My System Info

ECHO Please wait... Checking system information.

:: Section 1: Windows 10 information

ECHO ==========================

ECHO WINDOWS INFO

ECHO ============================

systeminfo | findstr /c:"OS Name"

systeminfo | findstr /c:"OS Version"

systeminfo | findstr /c:"System Type"

:: Section 2: Hardware information.

ECHO ============================

ECHO HARDWARE INFO

ECHO ============================

systeminfo | findstr /c:"Total Physical Memory"

wmic cpu get name

wmic diskdrive get name,model,size

wmic path win32_videocontroller get name

wmic path win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution

:: Section 3: Networking information.

ECHO ============================

ECHO NETWORK INFO

ECHO ============================

ipconfig | findstr IPv4
ipconfig | findstr IPv6

cd/Program Files(x86)/Securus/securusclient/

START https://github.com/

:: Section 4: Running Processes

ECHO ============================

ECHO RUNNING PROCESSES

ECHO ============================

tasklist

ECHO.
ECHO Top processes with memory usage:
tasklist /v

:: Section 5: Detailed OS Information

ECHO ============================

ECHO DETAILED OS INFO

ECHO ============================

wmic os get caption,version,buildnumber

ECHO.
ECHO Install Date:
systeminfo | findstr /c:"Install Date"

ECHO.
ECHO Last Boot Time:
wmic os get lastbootuptime

:: Section 6: Disk Space

ECHO ============================

ECHO DISK SPACE INFO

ECHO ============================

wmic logicaldisk get name,size,freespace

ECHO.
ECHO Volume Information (C:):
vol C:

:: Section 7: Memory Statistics

ECHO ============================

ECHO MEMORY STATISTICS

ECHO ============================

wmic os get totalmemory,freememory

:: Section 8: Network Connections

ECHO ============================

ECHO NETWORK CONNECTIONS & LISTENING PORTS

ECHO ============================

netstat -an

ECHO.
ECHO Routing Table:
route print

ECHO.
ECHO ARP Cache (MAC Addresses):
arp -a

:: Section 9: Network Diagnostics

ECHO ============================

ECHO NETWORK DIAGNOSTICS

ECHO ============================

ECHO Testing DNS resolution (Google):
nslookup google.com

ECHO.
ECHO Connectivity test (Localhost):
ping localhost

ECHO.
ECHO Trace route to Google:
tracert google.com

:: Section 10: User and Security Info

ECHO ============================

ECHO USER & SECURITY INFO

ECHO ============================

ECHO Current User:
whoami

ECHO.
ECHO User Accounts:
wmic useraccount list brief

ECHO.
ECHO Detailed User Information:
net user

ECHO.
ECHO Network Shares:
wmic share list brief

:: Section 11: Environment Variables

ECHO ============================

ECHO ENVIRONMENT VARIABLES

ECHO ============================

set

:: Section 12: File System Statistics

ECHO ============================

ECHO FILE SYSTEM STATISTICS

ECHO ============================

fsutil fsinfo statistics C:

:: Section 13: Power Settings

ECHO ============================

ECHO POWER SETTINGS

ECHO ============================

powercfg /query SCHEME_CURRENT

PAUSE
