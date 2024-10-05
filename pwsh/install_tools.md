
# PowerShell Script for Installing Essential Development, Security, and Networking Tools

This PowerShell script automates the installation of key development, security, and networking tools. 

It handles the setup of PowerShell modules, security utilities, and other development tools, ensuring a baseline environment for developers, security analysts, and system administrators.

## PowerShell Script

```powershell
#
# Written by David Hoyt 04-Oct-2024
#
#
#
# Switch to TLS 1.2 for secure package downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install NuGet provider if not installed
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser

# Update PowerShellGet for smooth module installations
Install-Module -Name PowerShellGet -Force -AllowClobber

# --------------------------
# Essential Development Tools
# --------------------------
Install-Module -Name Pester -Force              # PowerShell testing framework
Install-Module -Name PSReadline -Force          # Enhanced CLI with syntax highlighting
Install-Module -Name PSScriptAnalyzer -Force    # PowerShell script linter and analyzer
Install-Module -Name posh-git -Force            # Git integration with prompt enhancements
Install-Module -Name Az -AllowClobber -Force    # Azure PowerShell for cloud operations
Install-Module -Name DockerMsftProvider -Force  # Docker for Windows support

# -----------------------------------
# Security and Networking Tools (Pre, During, and Post-Exploitation)
# -----------------------------------
# Install security and post-exploitation modules
Install-Module -Name PowerSploit -Force         # PowerShell pentesting and post-exploitation framework
Install-Module -Name Nmap -Force                # Network scanning tool
Install-Module -Name PowerShellForGitHub -Force # Manage GitHub repositories from PowerShell

# Sysinternals Suite (Debugging and Security Analysis Tools)
$sysinternalsPath = "$env:ProgramFiles\Sysinternals"
if (-Not (Test-Path $sysinternalsPath)) {
    New-Item -ItemType Directory -Path $sysinternalsPath
}
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/SysinternalsSuite.zip" -OutFile "$sysinternalsPath\SysinternalsSuite.zip"
Expand-Archive -Path "$sysinternalsPath\SysinternalsSuite.zip" -DestinationPath $sysinternalsPath

# --------------------------
# Chocolatey Setup
# --------------------------
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# ----------------------------
# Install Developer, Security, and Networking Tools
# ----------------------------
# Pre-Exploitation and Reconnaissance Tools
choco install -y git python docker wireshark nmap openssl 7zip

# During Exploitation and Fuzzing Tools
choco install -y windbg metasploit radare2 yara

# Post-Exploitation and Debugging Tools
choco install -y sysinternals procdump

# --------------------------
# Optional: Additional Security Utilities
# --------------------------
# Install common utilities for cryptography and security analysis
choco install -y hashcat john rsactftool hydra gobuster sqlmap
```

## Script Breakdown

1. **TLS 1.2 Configuration**:  
   The script sets PowerShell to use TLS 1.2 for secure downloads of NuGet packages and Chocolatey.

2. **PowerShell Module Installation**:  
   The script installs essential PowerShell modules for development, security, and cloud operations:
   - `Pester`: Testing framework for PowerShell.
   - `PSReadline`: Enhanced CLI with syntax highlighting.
   - `PSScriptAnalyzer`: PowerShell script linter and analyzer.
   - `posh-git`: Git integration with PowerShell prompt enhancements.
   - `Az`: Azure PowerShell module for cloud operations.
   - `DockerMsftProvider`: Docker for Windows support.

3. **Security and Networking Tools**:  
   The script installs important security tools for pre-exploitation, post-exploitation, and networking analysis:
   - `PowerSploit`: PowerShell-based pentesting and post-exploitation framework.
   - `Nmap`: Network scanning and reconnaissance tool.
   - `PowerShellForGitHub`: Manage GitHub repositories directly from PowerShell.

4. **Sysinternals Suite**:  
   The Sysinternals Suite is downloaded and extracted for advanced debugging and security analysis.

5. **Chocolatey Setup**:  
   Chocolatey, a package manager for Windows, is installed to streamline the installation of software.

6. **Developer, Security, and Networking Tools via Chocolatey**:  
   The script installs a variety of tools using Chocolatey, organized into three categories:
   - **Pre-Exploitation and Reconnaissance**: Git, Python, Docker, Wireshark, Nmap, OpenSSL, 7-Zip.
   - **During Exploitation and Fuzzing**: WinDbg, Metasploit, Radare2, Yara.
   - **Post-Exploitation and Debugging**: Sysinternals, ProcDump.

7. **Optional Security Utilities**:  
   The script also installs additional cryptography and security analysis tools, such as Hashcat, John the Ripper, and Hydra.

## Usage Instructions

1. **Run the Script**:  
   Open PowerShell as an administrator and run the script to set up your environment with essential development and security tools.

2. **Customizing the Tools**:  
   Modify the Chocolatey and PowerShell module sections to add or remove tools according to your needs.

3. **Post-Execution**:  
   Once the script finishes, your system will have the necessary tools for development, security analysis, and networking.

## Important Notes

- **PowerShell Version**: Ensure you are using PowerShell 5.1 or higher.
- **Internet Connection**: This script requires an active internet connection to download tools and packages.
- **Administrator Access**: Administrator privileges are needed to install Chocolatey and system-wide packages.
