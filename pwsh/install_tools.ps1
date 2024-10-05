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
