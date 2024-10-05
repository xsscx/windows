Get-WmiObject -Class Win32_BaseBoard | Select-Object Product, Manufacturer
Get-WmiObject -Query "Select * from Win32_PnPEntity where DeviceID like '%PCI%'"
