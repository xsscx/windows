###########################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
#
## Date: 26-FEB-2025 2127 EST by David Hoyt
## Intent: ISE Powershell Developer Profile
#
## TODO: Refactor
##
# Open a Developer Powershell Terminal
# Run from ISE Powershell
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/ise_developer.ps1").Content
#
#
#
###########################################################

Write-Host "== Starting ise_developer.ps1 ==" -ForegroundColor Green
Write-Host "== Run from ISE Powershell ==" -ForegroundColor Cyan
Write-Host "Copyright (c) 2024-2025 David H Hoyt LLC. All rights reserved." -ForegroundColor White


$vsDevCmdPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"

# Ensure the path is correct
if (!(Test-Path $vsDevCmdPath)) {
    Write-Host "Error: VsDevCmd.bat not found at expected location." -ForegroundColor Red
    return
}

# Extract environment variables from VsDevCmd.bat and apply them
cmd /c "`"$vsDevCmdPath`" && set" | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], [System.EnvironmentVariableTarget]::Process)
    }
}

Write-Host "✅ VS Developer PowerShell Environment Loaded in PowerShell ISE." -ForegroundColor Green
