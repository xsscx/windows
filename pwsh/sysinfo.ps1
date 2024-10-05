# Collect system information using a combination of CIM commands

# Get serial numbers from BIOS using CIM
$biosSerial = Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty SerialNumber

# Get USB Hub information
$usbHubCim = Get-CimInstance -ClassName Win32_USBHub | Select-Object DeviceID, Description, Status

# Get PCI devices
$pciDevices = Get-CimInstance -ClassName Win32_PnPEntity | Where-Object { $_.Name -like "*PCI*" } | Select-Object Name, DeviceID

# Get USB Controller information using CIM
$usbControllersCim = Get-CimInstance -ClassName Win32_USBController | Select-Object Name, DeviceID, Status, Manufacturer

# Get Disk Drive information (USB drives specifically)
$usbDiskDrives = Get-CimInstance -ClassName Win32_DiskDrive | Where-Object { $_.InterfaceType -eq "USB" } | Select-Object Model, InterfaceType, MediaType, Size

# Get Network Adapter information
$networkAdapters = Get-NetAdapter | Select-Object Name, InterfaceDescription, Status, LinkSpeed

# Get Disk Drive information (all drives)
$diskDrives = Get-CimInstance -ClassName Win32_DiskDrive | Select-Object Model, InterfaceType, MediaType, Size

# Get Processor information
$processorInfo = Get-CimInstance -ClassName Win32_Processor | Select-Object Name, MaxClockSpeed, NumberOfCores, NumberOfLogicalProcessors

# Get computer system information
$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Manufacturer, Model, TotalPhysicalMemory

# Display collected information in the console
Write-Host "BIOS Serial Number:" $biosSerial
Write-Host "USB Hub Information:" $usbHubCim
Write-Host "PCI Devices:" $pciDevices
Write-Host "USB Controllers:" $usbControllersCim
Write-Host "USB Disk Drives:" $usbDiskDrives
Write-Host "Network Adapters:" $networkAdapters
Write-Host "All Disk Drives:" $diskDrives
Write-Host "Processor Info:" $processorInfo
Write-Host "Computer System Info:" $computerSystem

# Collect high-level system summary information
$os = Get-CimInstance Win32_OperatingSystem
$bios = Get-CimInstance Win32_BIOS
$cs = Get-CimInstance Win32_ComputerSystem
$proc = Get-CimInstance Win32_Processor

$output = @"
Operating System: $($os.Caption) $($os.Version) $($os.BuildNumber)
BIOS: $($bios.Manufacturer) $($bios.SMBIOSBIOSVersion)
System Manufacturer: $($cs.Manufacturer) $($cs.Model)
System Type: $($os.OSArchitecture)
Processor: $($proc.Name)
"@

# Output the collected system summary to a text file
$output | Out-File -FilePath "C:\tmp\system_info.txt"

# Output summary to the console
Write-Host $output
