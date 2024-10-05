###########################################################
#
## Copyright (©) 2024 David H Hoyt. All rights reserved.
## 
## Last Updated: 20-FEB-2025 at 0753 EST by David Hoyt (©)
#
## Intent: Neuter MpPreference Disable_{attribute|value}
#
## TODO: Refactor
#
###########################################################

Write-Host "== Starting Windows DisableMpPreference.ps1 ==" -ForegroundColor Green
Write-Host "Copyright (c) 2025 David H Hoyt LLC. All rights reserved." -ForegroundColor White

Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisablePrivacyMode $true
Set-MpPreference -DisableScriptScanning $true
