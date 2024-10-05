
# SQL Server Installation Checker

This PowerShell script checks if Microsoft SQL Server is installed on a Windows machine by accessing specific registry paths.
If installed, it retrieves the version and edition of the installed instances and outputs the result.

## Script Overview

- **Registry Path**: The script queries the Windows registry at `HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server` to check for installed SQL Server instances.
- **Installed Instances**: It reads the `InstalledInstances` property to identify the names of the installed instances.
- **Instance Details**: For each instance, the script retrieves:
  - **Edition**: The edition of SQL Server (e.g., Standard, Enterprise).
  - **Version**: The version of SQL Server (e.g., 14.0, 15.0).

## Output

If SQL Server is installed, the script outputs the version and edition of the installed SQL Server instances in the following format:

```
<version>:<edition>
```

For example, `15.0:Enterprise`.

If no SQL Server instances are installed, the script does not return any output.

## Usage

1. Open PowerShell as Administrator.
2. Run the script:

```powershell
.\sql_server_check.ps1
```

The script will check for installed SQL Server instances and output the version and edition if any are found.

## Requirements

- Windows OS
- PowerShell
- Administrator privileges (to access the registry)

