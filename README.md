# Welcome to Hoyt's Windows Fuzzing & Mining Repo
04 NOV 2024 at 0650 EST


## Cross-Platform Tool Installation with Powershell Scripts

### Overview

#### Transitioning to Powershell from Unix.
 
This write-up demonstrates how to automate tool installation with shell scripts, enabling quick setup of development environments across Windows and macOS

### Why Use This Approach?

By using a single command to download and execute scripts, this approach minimizes the friction of setting up development environments. 

It's similar to how Homebrew and package managers like `apt` work in Unix-based systems. 

This method offers several advantages:

- **Cross-Platform Familiarity**: Developers used to Linux/macOS environments will find the workflow familiar.
- **Consistency**: It standardizes the installation process across platforms, reducing complexity.
- **Rapid Setup**: Just like `brew` or `curl | bash` setups on macOS/Linux, you can get up and running quickly on Windows.
- **Automation Friendly**: These scripts are perfect for CI/CD pipelines and automated environments, reducing manual effort.

### Installation Examples

#### Install Tools from Remote

This command allows you to install necessary tools directly from a remote repository. It downloads and executes the installation script in one step.

```powershell
iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/install_tools.ps1").Content
```

#### Harvest Local Data

To harvest local data, you can use this script, which simplifies extracting audit logs or other relevant data for analysis.

```powershell
https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/unifiedauditlog-ytd-harvest-sample-001.ps1
```

#### Perform Lateral Checks (SQL Server Example)

This script helps you perform lateral checks on an SQL Server. It can be useful for auditing configurations or monitoring server health.

```powershell
https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/sql_server_check.ps1
```

### Summary

1. **Easy to Learn**: Developers from different platforms will recognize the pattern of downloading and running scripts.
2. **Quick Setup**: Get your development environment ready in one line, similar to using `brew` on macOS.
3. **CI/CD Compatibility**: These scripts can be easily integrated into automated workflows, making them ideal for testing and deployments.

---

## Repo Coverage

```
Windows Server
Windows 11 Pro Enterprise
M365E5D2P2
Enterprise Software Products
```


