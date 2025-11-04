###########################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
#
## Date: 24-FEB-2025 1325 EST by David Hoyt
## Intent: Poll the Device and Report for Troubleshooting
#
## TODO: Refactor
##
# Open a Developer Powershell Terminal
# cd to $Project_Root/
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/windev_troubleshooter.ps1").Content
#
#
#
###########################################################

Write-Host "== Starting Windows Development Troubleshooter ==" -ForegroundColor Green
Write-Host "== Run from Project_Root/ ==" -ForegroundColor Cyan
Write-Host "Copyright (c) 2024-2025 David H Hoyt LLC. All rights reserved." -ForegroundColor White


function Format-Hyperlink {
  param(
    [Parameter(ValueFromPipeline = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [Uri] $Uri,

    [Parameter(Mandatory=$false, Position = 1)]
    [string] $Label
  )

  if (($PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows) -and -not $Env:WT_SESSION) {
    # Fallback for Windows users not inside Windows Terminal
    if ($Label) {
      return "$Label ($Uri)"
    }
    return "$Uri"
  }

  if ($Label) {
    return "`e]8;;$Uri`e\$Label`e]8;;`e\"
  }

  return "$Uri"
}

function Format-Hyperlink {
  param(
    [Parameter(ValueFromPipeline = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [Uri] $Uri,

    [Parameter(Mandatory=$false, Position = 1)]
    [string] $Label
  )

  if (($PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows) -and -not $Env:WT_SESSION) {
    # Fallback for Windows users not inside Windows Terminal
    if ($Label) {
      return "$Label ($Uri)"
    }
    return "$Uri"
  }

  if ($Label) {
    return "`e]8;;$Uri`e\$Label`e]8;;`e\"
  }

  return "$Uri"
}

# Collect system information using a combination of CIM commands

systeminfo

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
$output | Out-File -FilePath "system_info.txt"

# Output summary to the console
Write-Host $output


# Initialize report
$Report = @()

# Function to add to the report
function AddToReport {
    param (
        [string]$Tool,
        [string]$Status,
        [string]$Details
    )
    $Report += [PSCustomObject]@{
        Tool    = $Tool
        Status  = $Status
        Details = $Details
    }
}

# Check vcpkg
if (Get-Command vcpkg -ErrorAction SilentlyContinue) {
    $vcpkgVersion = vcpkg --version 2>&1 | Out-String
    # $vcpkgPackages = vcpkg list 2>&1 | Out-String
    AddToReport -Tool "vcpkg" -Status "Found" -Details "Version: $vcpkgVersion`nPackages:`n$vcpkgPackages"
} else {
    AddToReport -Tool "vcpkg" -Status "Not Found" -Details "vcpkg is not installed or not in PATH."
}

# Check Visual Studio installations using vswhere
if (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe") {
    $vsInstances = &"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -format json | ConvertFrom-Json
    if ($vsInstances) {
        foreach ($instance in $vsInstances) {
            AddToReport -Tool "Visual Studio" -Status "Found" -Details "Edition: $($instance.installationName), Version: $($instance.installationVersion), Path: $($instance.installationPath)"
        }
    } else {
        AddToReport -Tool "Visual Studio" -Status "Not Found" -Details "No Visual Studio installations detected."
    }
} else {
    AddToReport -Tool "Visual Studio" -Status "Not Found" -Details "vswhere.exe not found."
}

# Check .NET SDKs
if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    $dotnetSdks = dotnet --list-sdks 2>&1 | Out-String
    $dotnetRuntimes = dotnet --list-runtimes 2>&1 | Out-String
    AddToReport -Tool ".NET SDK" -Status "Found" -Details "SDKs:`n$dotnetSdks`nRuntimes:`n$dotnetRuntimes"
} else {
    AddToReport -Tool ".NET SDK" -Status "Not Found" -Details ".NET SDK is not installed or not in PATH."
}

# Check Chocolatey
if (Get-Command choco -ErrorAction SilentlyContinue) {
    $chocoVersion = choco --version 2>&1 | Out-String
    $chocoPackages = choco list --local-only 2>&1 | Out-String
    AddToReport -Tool "Chocolatey" -Status "Found" -Details "Version: $chocoVersion`nPackages:`n$chocoPackages"
} else {
    AddToReport -Tool "Chocolatey" -Status "Not Found" -Details "Chocolatey is not installed or not in PATH."
}

# Check Node.js and npm
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = node --version 2>&1 | Out-String
    $npmVersion = npm --version 2>&1 | Out-String
    AddToReport -Tool "Node.js & npm" -Status "Found" -Details "Node.js Version: $nodeVersion`nnpm Version: $npmVersion"
} else {
    AddToReport -Tool "Node.js & npm" -Status "Not Found" -Details "Node.js and npm are not installed or not in PATH."
}

# Final Report
Write-Host "`n=== Developer Tools Report ===`n" -ForegroundColor Cyan
$Report | Format-Table -AutoSize -Property Tool, Status, Details

# Collect system summary information
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

# Output summary to the console
Write-Host $output


# This script checks if SQL Server is installed on Windows

    [string] $SqlInstalled = ""
    $regPath = 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server'
    if (Test-Path $regPath) {
        $inst = (get-itemproperty $regPath).InstalledInstances
        #$SqlInstalled = ($inst.Count -gt 0)
        foreach ($i in $inst) {
            # Read registry data
            #
            $p = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$i
            $setupValues = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup")
            $edition = ($setupValues.Edition -split ' ')[0]
            $version = ($setupValues.Version)
            $SqlInstalled =  $version, $edition -join ':'
        }
    }
    Write-Output $SqlInstalled




# 1. List Visual Studio Installations with Edition, Version, Path, and devenv.exe
&"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -format json | ConvertFrom-Json | ForEach-Object { [PSCustomObject]@{ Edition = $_.installationName.Split("/")[-1]; Version = $_.installationVersion; Path = $_.installationPath; DevenvExecutable = "$($_.installationPath)\Common7\IDE\devenv.exe" } } | Format-Table -AutoSize

# 2. List Only Installation Paths
&"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath

# 3. List Visual Studio Editions (e.g., Community, Professional, Enterprise)
&"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -property installationName

# 4. List All Installed Visual Studio Versions
&"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -property installationVersion

# 5. Query All Installed Visual Studio Instances with Details
&"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -all -format json | ConvertFrom-Json | Format-Table -Property instanceId, installationName, installationPath, installationVersion -AutoSize

# 6. List Installed CMake Versions
# Get-Command cmake | Select-Object -ExpandProperty Source | ForEach-Object { "$_" }

# 7. Query vcpkg Installation Path
Get-Command vcpkg | Select-Object -ExpandProperty Source | Split-Path

# 8. Find Installed Python Versions (Assuming python and python3 in PATH)
# &python --version; &python3 --version

# 9. Check Node.js and npm Versions
# node --version; npm --version

# 10. Check Git Version and Configuration
git --version; git config --list

# 11. Query All Installed .NET SDK Versions
# dotnet --list-sdks

# 12. Query All Installed .NET Runtimes
# dotnet --list-runtimes

# 13. Check Java Installation (Assuming java in PATH)
# java -version

# 14. Query Active PowerShell Version
$PSVersionTable.PSVersion

# 15. Check Disk Space on Drives
Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free, @{n='Total';e={$_.Used + $_.Free}} | Format-Table -AutoSize

# 16. Query System Uptime
(Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime

# 17. List Running Processes with Memory Usage
Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 10 -Property Name, Id, @{Name='Memory(MB)';Expression={[math]::Round($_.WS / 1MB, 2)}} | Format-Table -AutoSize

# 18. List Active Network Connections
Get-NetTCPConnection | Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, State | Format-Table -AutoSize

# 19. List All Open Ports
netstat -an | Select-String LISTENING

# 20. Query Installed Packages Using Chocolatey (if Installed)
# choco list

Get-ExecutionPolicy -List

Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture
Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer, Model
Get-CimInstance Win32_Processor | Select-Object Name, MaxClockSpeed, NumberOfCores
if (Get-Command git -ErrorAction SilentlyContinue) { & "git" --version } else { "Git not found." }
if (Get-Command python -ErrorAction SilentlyContinue) { & "python" --version } else { "Python not found." }
$env:PATH -split ";"
Get-ChildItem Env:
&"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -format json | ConvertFrom-Json
if (Get-Command msbuild -ErrorAction SilentlyContinue) { & "msbuild" -version } else { "MSBuild not found." }
if (Get-Command cmake -ErrorAction SilentlyContinue) { & "cmake" --version } else { "CMake not found." }
if (Test-Path .\vcpkg.exe) { & .\vcpkg.exe version } else { "vcpkg not found in current directory." }




# Function to log messages with timestamp
function Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$TimeStamp - [$Level] $Message"
}

# Function to log banner
function LogBanner {
    param ([string]$Title)
    $Banner = "*" * 50
    Write-Output "$Banner"
    Write-Output "* $Title"
    Write-Output "$Banner"
}

# Function to collect system information
function Get-SystemInfo {
    LogBanner -Title "System Information"
    Log "Collecting operating system details..."
    Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture | Format-Table -AutoSize

    Log "Collecting hardware details..."
    Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer, Model | Format-Table -AutoSize
    Get-CimInstance Win32_Processor | Select-Object Name, MaxClockSpeed, NumberOfCores | Format-Table -AutoSize
}

# Function to collect software environment details
function Get-SoftwareInfo {
    LogBanner -Title "Software Information"
    Log "Checking for Git..."
    if (Get-Command git -ErrorAction SilentlyContinue) {
        & "git" --version | ForEach-Object { Log "Git Version: $_" }
    } else {
        Log "Git not found." -Level "WARNING"
    }

    Log "Checking for Python..."
    if (Get-Command python -ErrorAction SilentlyContinue) {
        & "python" --version | ForEach-Object { Log "Python Version: $_" }
    } else {
        Log "Python not found." -Level "WARNING"
    }

    Log "Checking for MSBuild..."
    if (Get-Command msbuild -ErrorAction SilentlyContinue) {
        & "msbuild" -version | ForEach-Object { Log "MSBuild Version: $_" }
    } else {
        Log "MSBuild not found." -Level "WARNING"
    }

    Log "Checking for CMake..."
    if (Get-Command cmake -ErrorAction SilentlyContinue) {
        & "cmake" --version | ForEach-Object { Log "CMake Version: $_" }
    } else {
        Log "CMake not found." -Level "WARNING"
    }

    Log "Checking for vcpkg..."
    if (Test-Path .\vcpkg.exe) {
        & .\vcpkg.exe version | ForEach-Object { Log "vcpkg Version: $_" }
    } else {
        Log "vcpkg not found in the current directory." -Level "WARNING"
    }
}

# Function to collect environment variables
function Get-EnvironmentInfo {
    LogBanner -Title "Environment Information"
    Log "Collecting PATH environment variable..."
    $env:PATH -split ";" | ForEach-Object { Log $_ }

    Log "Listing all environment variables..."
    Get-ChildItem Env: | Format-Table -AutoSize
}

# Function to collect Visual Studio installations
function Get-VSInfo {
    LogBanner -Title "Visual Studio Information"
    Log "Checking for Visual Studio installations..."
    $vswherePath = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
    if (Test-Path $vswherePath) {
        & $vswherePath -format json | ConvertFrom-Json | Format-Table -AutoSize
    } else {
        Log "vswhere.exe not found. Ensure Visual Studio is installed." -Level "WARNING"
    }
}

# Run system diagnostics
Write-Host "`n== Gathering System Information... ==" -ForegroundColor Green
systeminfo | Out-Host

Write-Host "`n== Checking Installed Development Tools... ==" -ForegroundColor Green
(Get-Command -Name devenv -ErrorAction SilentlyContinue).Source | Out-Host
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"

Write-Host "`n== Checking Installed Modules... ==" -ForegroundColor Green
Get-InstalledModule | Select-Object Name, Version | Out-Host

Write-Host "`n== Checking Environment Variables... ==" -ForegroundColor Green
Get-ChildItem Env: | Out-Host

Write-Host "`n== Checking Available Disk Space... ==" -ForegroundColor Green
Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free, @{n='FreeGB';e={[math]::Round($_.Free / 1GB, 2)}} | Out-Host

Write-Host "`n== Checking for vswhere.exe... ==" -ForegroundColor Green
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"

[System.Text.Encoding]::Default
cl /Bv | FindStr "Version"

# 1. List all local branches
git branch

# 5. Show the current repository status
git status -s

# 6. List all configured remotes and their URLs
git remote -v

cat CMakeCache.txt

LogBanner -Title "End of Troubleshooting Report"
Log "Troubleshooting completed successfully."

Write-Host "============================= Exiting Windows Development Troubleshooter =============================" -ForegroundColor White
