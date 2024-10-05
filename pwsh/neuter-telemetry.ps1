###########################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
#
## Date: 26-FEB-2025 2127 EST by David Hoyt
## Intent: Neuter Telemetry
#
## TODO: Refactor
##
# Open a Developer Powershell Terminal
# cd to $Project_Root/
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/neuter-telemetry.ps1").Content
#
#
#
###########################################################

Write-Host "== Starting Neuter Telemetry ==" -ForegroundColor Green
Write-Host "== Run from Developer Powershell ==" -ForegroundColor Cyan
Write-Host "Copyright (c) 2024-2025 David H Hoyt LLC. All rights reserved." -ForegroundColor White

# Disable .NET CLI Telemetry
[System.Environment]::SetEnvironmentVariable("DOTNET_CLI_TELEMETRY_OPTOUT", "1", "Machine")

# Disable vcpkg Telemetry
[System.Environment]::SetEnvironmentVariable("VCPKG_DISABLE_METRICS", "1", "Machine")

# Disable PowerShell Telemetry
[System.Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", "1", "Machine")

# Disable Windows Package Manager (winget) Telemetry
[System.Environment]::SetEnvironmentVariable("WINGETTELEMETRYOPTOUT", "1", "Machine")

# Disable Git Experimental Features (limits metadata collection)
git config --global feature.manyFiles off

# Disable Visual Studio Telemetry
[System.Environment]::SetEnvironmentVariable("VSTEL_EXPERIMENTATION_OPT_OUT", "1", "Machine")
[System.Environment]::SetEnvironmentVariable("VS_DISABLE_EXPERIMENTATION", "1", "Machine")

# Disable NPM Telemetry
[System.Environment]::SetEnvironmentVariable("NPM_CONFIG_METRICS", "false", "Machine")
[System.Environment]::SetEnvironmentVariable("NPM_CONFIG_SEND_METRICS", "false", "Machine")

# Disable Python Pip Telemetry
[System.Environment]::SetEnvironmentVariable("PIP_NO_TRACKING", "1", "Machine")

# Disable Cargo (Rust) Telemetry
[System.Environment]::SetEnvironmentVariable("CARGO_TELEMETRY", "0", "Machine")

# Disable Azure CLI Telemetry
[System.Environment]::SetEnvironmentVariable("AZURE_CORE_COLLECT_TELEMETRY", "0", "Machine")

# Disable Kubernetes (kubectl) Telemetry
[System.Environment]::SetEnvironmentVariable("KUBECTL_TELEMETRY_DISABLED", "1", "Machine")

# Disable Terraform Telemetry
[System.Environment]::SetEnvironmentVariable("TF_CLI_ARGS", "-no-color", "Machine")
[System.Environment]::SetEnvironmentVariable("CHECKPOINT_DISABLE", "1", "Machine")

# Disable Ansible Telemetry
[System.Environment]::SetEnvironmentVariable("ANSIBLE_GALAXY_NO_ANONYMOUS_USAGE_STATS", "True", "Machine")

# Disable Homebrew Telemetry (if installed on Windows)
[System.Environment]::SetEnvironmentVariable("HOMEBREW_NO_ANALYTICS", "1", "Machine")

# Apply changes to the current session
$env:DOTNET_CLI_TELEMETRY_OPTOUT = "1"
$env:VCPKG_DISABLE_METRICS = "1"
$env:POWERSHELL_TELEMETRY_OPTOUT = "1"
$env:WINGETTELEMETRYOPTOUT = "1"
$env:VSTEL_EXPERIMENTATION_OPT_OUT = "1"
$env:VS_DISABLE_EXPERIMENTATION = "1"
$env:NPM_CONFIG_METRICS = "false"
$env:NPM_CONFIG_SEND_METRICS = "false"
$env:PIP_NO_TRACKING = "1"
$env:CARGO_TELEMETRY = "0"
$env:AZURE_CORE_COLLECT_TELEMETRY = "0"
$env:KUBECTL_TELEMETRY_DISABLED = "1"
$env:TF_CLI_ARGS = "-no-color"
$env:CHECKPOINT_DISABLE = "1"
$env:ANSIBLE_GALAXY_NO_ANONYMOUS_USAGE_STATS = "True"
$env:HOMEBREW_NO_ANALYTICS = "1"

# Confirm settings (optional)
Write-Host "Telemetry disabled for multiple tools. Restart required for full effect."
