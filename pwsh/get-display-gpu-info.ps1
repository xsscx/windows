
###########################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
#
## Date: 26-FEB-2025 2127 EST by David Hoyt
## Intent: Get Nvidia & Display Info
#
## TODO: Refactor
##
# Open a Developer Powershell Terminal
# 
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/get-display-gpu-info.ps1").Content
#
#
#
###########################################################

Write-Host "=========== Get GPU & Display Info Script | Start ===============" -ForegroundColor White
Write-Host "== Run from Developer Powershell ==" -ForegroundColor Cyan
Write-Host "Copyright (c) 2024-2025 David H Hoyt LLC. All rights reserved." -ForegroundColor White


Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, PNPDeviceID, VideoModeDescription, CurrentRefreshRate, AdapterRAM
nvidia-smi --query-gpu=name,driver_version,memory.used,memory.total,utilization.gpu --format=csv
dxdiag /t "$env:Temp\dxdiag.txt"; Start-Sleep -Seconds 2; Get-Content "$env:Temp\dxdiag.txt" | Select-String "Card name","Driver Version","Current Mode","Monitor Model"
Get-PnpDevice -Class Monitor | Format-Table Status, Class, FriendlyName, InstanceId -AutoSize
Get-PnpDevice -Class Display | Select-Object FriendlyName, DriverVersion, Manufacturer, Present
pnputil /enum-drivers | Select-String "Display"
pnputil /enum-drivers | Select-String "Graphics"
pnputil /scan-devices
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /s
powercfg /query SCHEME_CURRENT SUB_VIDEO
msinfo32 /report "$env:Temp\msinfo32_display.txt"; Start-Sleep -Seconds 2; Get-Content "$env:Temp\msinfo32_display.txt" | Select-String "Name","Driver","Resolution","Refresh"

Write-Host "=========== Get GPU & Display Info Script | End  ===============" -ForegroundColor White
