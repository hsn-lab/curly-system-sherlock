# System Sherlock

A comprehensive batch script for Windows systems that gathers detailed system and network information. Perfect for learning about your computer's configuration and diagnosing system issues.

## Overview

**System Sherlock** provides an easy-to-use batch script that displays comprehensive information about your Windows system, hardware, networking configuration, and running processes. This tool is ideal for system administrators, IT professionals, and anyone curious about their computer's specifications.

## Features

The `wow.bat` script collects and displays:

### 1. **Windows OS Information**
- OS Name, Version, and Build Number
- System Type (x86 or x64)
- Installation Date and Last Boot Time

### 2. **Hardware Details**
- CPU Information
- Total Physical Memory
- Disk Drives (Name, Model, Size)
- Graphics Card Details and Resolution

### 3. **Network Information**
- IPv4 and IPv6 Addresses
- Network Configuration (IPCONFIG)
- Connected Devices and Drivers

### 4. **Running Processes**
- List of all active processes
- Process details with memory usage statistics

### 5. **Disk Space Analysis**
- Logical Disk Storage (Size and Free Space)
- Volume Information

### 6. **Memory Statistics**
- Total System Memory
- Available Free Memory

### 7. **Network Connections**
- Active network connections and listening ports
- Routing table information
- ARP cache (MAC addresses)

### 8. **Network Diagnostics**
- DNS resolution testing
- Connectivity tests (Localhost ping)
- Route tracing to external hosts

### 9. **User and Security**
- Current logged-in user
- User accounts on the system
- Network shares

### 10. **System Settings**
- Environment Variables
- File System Statistics
- Power Configuration

## Usage

1. **Download or Clone** this repository
2. **Run the Script**: Double-click `wow.bat` or run it from Command Prompt:
   ```cmd
   wow.bat
   ```
3. **Review Output**: The script will display all system information in the console window

## Requirements

- Windows 10 or later (recommended)
- Administrator privileges (for accessing some system information)
- Command Prompt or PowerShell

## Files

- **wow.bat** - Main system information gathering script
- **README.md** - This file
- **LICENSE** - Project license

## Learning Objectives

This script helps you learn about:
- Batch scripting fundamentals
- Windows command-line utilities
- System administration commands
- Network diagnostics tools
- WMI (Windows Management Instrumentation) queries

## Common Commands Used

| Command | Purpose |
|---------|---------|
| `systeminfo` | Display detailed OS and hardware info |
| `wmic` | Query system components |
| `ipconfig` | Show network configuration |
| `tasklist` | List running processes |
| `netstat` | Display network connections |
| `tracert` | Trace network routes |
| `nslookup` | Resolve DNS names |
| `powercfg` | Query power settings |

## Tips

- **Run as Administrator** for complete system information
- **Redirect Output**: Save output to a file with `wow.bat > system_info.txt`
- **Scheduled Runs**: Use Windows Task Scheduler to run periodically for system monitoring

## License

This project is licensed under the terms specified in the LICENSE file.

## Contributing

Feel free to fork this project, submit issues, or improve the script!

---

**Happy system exploring! 🔍**
