
# PowerShell Script for Gathering System Information

## Overview

This PowerShell script collects a wide range of system and hardware information from a Windows machine using a combination of CIM and WMI commands. It retrieves details about BIOS, USB hubs, PCI devices, disk drives, network adapters, processor, and system manufacturer, as well as outputs a system summary (OS version, BIOS version, etc.).

## Script Functionality

1. **BIOS Information**:
    - Retrieves the BIOS serial number using both CIM and WMI.
2. **USB Hubs**:
    - Lists all USB hubs with details like `DeviceID`, `Description`, and `Status`.
3. **PCI Devices**:
    - Lists all PCI devices detected on the machine, including their names and device IDs.
4. **USB Controllers**:
    - Provides information on USB controllers, including their status and manufacturer.
5. **Disk Drives**:
    - Lists both USB disk drives and all other disk drives, showing their model, interface type, media type, and size.
6. **Network Adapters**:
    - Lists network adapters with details like `Name`, `InterfaceDescription`, `Status`, and `LinkSpeed`.
7. **Processor**:
    - Displays the processor information, including clock speed, number of cores, and logical processors.
8. **System Manufacturer**:
    - Retrieves the system's manufacturer, model, and total physical memory.
9. **Operating System Summary**:
    - Outputs key summary information about the operating system, BIOS, system manufacturer, system type (e.g., 64-bit), and processor name.

## Prerequisites

1. **PowerShell Version**: Ensure PowerShell 5.0 or higher is installed.
2. **Permissions**: You might need administrative privileges to retrieve certain hardware information.
3. **Output Location**: The script will write a summary of system details to the file `C:\tmp\system_info.txt`. Ensure the directory exists, or modify the script to point to another location.

## How to Use

1. **Edit the script** (optional):
    - You can customize the output file path or adjust the commands based on your needs.
2. **Run the script**: 
    - Open PowerShell with the necessary permissions and execute the script.
3. **View the output**:
    - The script will display detailed hardware information in the console and write a high-level summary to `C:\tmp\system_info.txt`.

### Example Output

**Console Output**:
```plaintext
BIOS Serial Number: 25C2XP3
USB Hub Information: @{DeviceID=USB\ROOT_HUB30\4&AD0D9FA&0&0; Description=USB Root Hub (USB 3.0); Status=OK} ...
PCI Devices: @{Name=Intel(R) Xeon(R) processor P family/Core i7 PCI Express Root Port A - 2030; DeviceID=PCI\VEN_8086&DEV_2030...} ...
USB Controllers: @{Name=Intel(R) USB 3.0 eXtensible Host Controller - 1.0 (Microsoft); DeviceID=PCI\VEN_8086&DEV_A1AF&SUBSYS_07391028&REV_09...} ...
Operating System: Microsoft Windows 11 Pro 10.0.22631 22631
BIOS: Dell Inc. 2.41.0
System Manufacturer: Dell Inc. Precision 7820 Tower
System Type: 64-bit
Processor: Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz
```

**File Output** (`C:\tmp\system_info.txt`):
```plaintext
Operating System: Microsoft Windows 11 Pro 10.0.22631 22631
BIOS: Dell Inc. 2.41.0
System Manufacturer: Dell Inc. Precision 7820 Tower
System Type: 64-bit
Processor: Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz
```

