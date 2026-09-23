# System Sherlock

System Sherlock is a **read-only Windows inventory and diagnostics tool** written as a batch script. It is intended for systems you own or are explicitly authorized to assess.

## What changed

The script now:

- Produces timestamped reports in `reports\` instead of only flooding the console.
- Supports `/quick`, `/full`, `/network`, `/quiet`, and `/out FILE` modes.
- Uses modern PowerShell CIM queries where practical, with native-command fallbacks for common inventory tasks.
- Records the current access context and treats `Access is denied` as a diagnostic finding.
- Makes potentially noisy network tests opt-in with `/network`.
- Avoids dumping the complete environment, opening external websites, changing directories unexpectedly, or attempting privilege escalation.
- Includes security-posture checks for Defender, BitLocker, event logs, active services, and sessions when Windows exposes them to the current user.

## Usage

From Command Prompt:

```cmd
wow.bat
wow.bat /full /network
wow.bat /quiet /out C:\Temp\sherlock.txt
wow.bat /help
```

Reports are saved to `reports\system-sherlock-YYYYMMDD-HHMMSS.txt` by default. The report can contain usernames, hostnames, IP addresses, process names, and event metadata. Review and redact it before sharing.

## About access restrictions

System Sherlock does **not** bypass Windows permissions, UAC, endpoint-security controls, or account restrictions. There is no legitimate general-purpose way to “get around” an access control without authorization. Instead, the tool helps administrators work within least-privilege boundaries:

1. Run the standard user mode first.
2. Review the report for explicitly denied commands.
3. Ask the system owner for the minimum documented role or read-only delegation required.
4. If approved, run the same script from an authorized administrator session and compare results.
5. Do not disable security software, change ACLs, harvest credentials, or use exploit-based elevation.

Use a lab VM or an approved test host when evaluating permissions. Obtain written authorization and follow your organization’s change-control and incident-response procedures.

## Requirements

- Windows 10/11 or Windows Server with `cmd.exe`.
- PowerShell is recommended for CIM and security-posture sections.
- Administrator rights are **not required**, but some fields will be unavailable to standard users.

## Safety notes

- The script performs inventory and diagnostics only; it does not modify system state.
- Network diagnostics are opt-in because they generate traffic.
- Never upload an unredacted report if it contains internal hostnames, addresses, usernames, or process details.
