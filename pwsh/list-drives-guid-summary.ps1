Get-WmiObject -Class Win32_DiskDrive | Select-Object DeviceID, Model, @{Name="DiskSignature";Expression={(Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($_.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition" | Select-Object -First 1).DiskSignature}} | Format-Table -AutoSize
Get-PhysicalDisk | Select-Object DeviceID, Model, UniqueId | Format-Table -AutoSize
