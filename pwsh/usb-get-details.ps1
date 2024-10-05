# USB Devices
Write-Host "USB Devices:"
Get-CimInstance -ClassName Win32_USBHub | Select-Object DeviceID, Description, Status

# PCI Devices (Including Thunderbolt)
Write-Host "`nPCI Devices (Including Thunderbolt):"
Get-CimInstance -ClassName Win32_PnPEntity | Where-Object { $_.PNPDeviceID -like "*PCI*" } | Select-Object Name, DeviceID

# USB Controllers
Write-Host "`nUSB Controllers:"
Get-CimInstance -ClassName Win32_USBController | Select-Object Name, DeviceID, Status, Manufacturer

# Disk Drives
Write-Host "`nStorage Devices:"
Get-CimInstance -ClassName Win32_DiskDrive | Select-Object Model, InterfaceType, MediaType, Size
