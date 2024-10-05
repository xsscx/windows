Get-WmiObject Win32_PnPEntity | Where-Object { $_.PNPDeviceID -like "*PCI*" } | Select-Object Name, DeviceID, Manufacturer, Status
