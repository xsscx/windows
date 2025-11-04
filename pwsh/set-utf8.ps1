###############################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
##                 https://srd.cx
##
## Last Updated: 04-NOV-2025 1400Z by David Hoyt
#
## Intent: Check Set Code Page on Windows in pwsh
#
## TODO:
#
#
#
#
#
#
#
#
#
###############################################################

Write-Host "Detecting OS..." -ForegroundColor Cyan

$os = $PSVersionTable.OS
if ($os -match "Windows") {
    $platform = "Windows"
} elseif ($os -match "Linux") {
    $platform = "Linux"
} elseif ($os -match "Darwin") {
    $platform = "macOS"
} else {
    $platform = "Unknown"
}

Write-Host "Detected OS: $platform"

Write-Host "Configuring UTF-8 devenv...." -ForegroundColor Cyan

# Set output encoding
$OutputEncoding = [System.Text.UTF8Encoding]::new()

# Set system code page (Windows only)
if ($platform -eq "Windows") {
    try {
        chcp 65001 | Out-Null
        Write-Host "Console code page set to UTF-8 (65001)." -ForegroundColor Green
    } catch {
        Write-Warning "Unable to change code page. Try running as Administrator."
    }
}

# Export environment variables
$env:LANG = "en_US.UTF-8"
$env:LC_ALL = "en_US.UTF-8"
$env:LC_CTYPE = "en_US.UTF-8"

# Verify current configuration
Write-Host "`n=== Locale / Encoding Check ===" -ForegroundColor Yellow
Write-Host ("PowerShell OutputEncoding : " + $OutputEncoding.WebName)
Write-Host ("Console Code Page         : " + (chcp | Out-String).Trim())
Write-Host ("LANG                      : " + $env:LANG)
Write-Host ("LC_CTYPE                  : " + $env:LC_CTYPE)
Write-Host ("LC_ALL                    : " + $env:LC_ALL)

Write-Host "`nUTF-8 devenv configured successfully.`n" -ForegroundColor Green
