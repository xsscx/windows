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
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/get-display-nvidia-info.ps1").Content
#
#
#
###########################################################

Write-Host "=========== Get Nvidia & Display Info Script | Start ===============" -ForegroundColor White
Write-Host "== Run from Developer Powershell ==" -ForegroundColor Cyan
Write-Host "Copyright (c) 2024-2025 David H Hoyt LLC. All rights reserved." -ForegroundColor White


Get-WinEvent -LogName System | Where-Object Id -in 42,13 | Format-Table TimeCreated, Id, Message -AutoSize
pnputil /enum-drivers | Select-String "Dell"
Get-PnpDevice -Class Monitor | Format-Table Status, Class, FriendlyName, InstanceId -AutoSize
Get-WmiObject Win32_VideoController | Select-Object Name, DriverVersion, Status
nvidia-smi --query-gpu=name,driver_version,memory.used,memory.total,utilization.gpu --format=csv
dxdiag /t "$env:Temp\dxdiag.txt"; Get-Content "$env:Temp\dxdiag.txt" | Select-String "Card name","Driver Version","Current Mode"
pnputil /enum-drivers | Select-String "Display"
Get-PnpDevice -Class Display | Select-Object FriendlyName, DriverVersion, Manufacturer
wmic path win32_videocontroller get name, driverversion, pnpdeviceid
pnputil /scan-devices
Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, PNPDeviceID

Write-Host "=========== Get Nvidia & Display Info Script | End  ===============" -ForegroundColor White
