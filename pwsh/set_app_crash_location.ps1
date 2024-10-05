# Define the custom crash dump directory
$customDumpFolder = "c:\crash"

# Check if the custom directory exists, if not, create it
if (-not (Test-Path $customDumpFolder)) {
    Write-Host "Creating custom crash dump directory at $customDumpFolder..."
    New-Item -Path $customDumpFolder -ItemType Directory | Out-Null
    Write-Host "Directory created."
} else {
    Write-Host "Custom crash dump directory already exists at $customDumpFolder."
}

# Set the registry path for WER LocalDumps
$localDumpsKey = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps"

# Check if the LocalDumps key exists, if not, create it
if (-not (Test-Path $localDumpsKey)) {
    Write-Host "Creating LocalDumps registry key..."
    New-Item -Path $localDumpsKey | Out-Null
    Write-Host "LocalDumps key created."
}

# Set the DumpFolder to the custom location for all applications
Set-ItemProperty -Path $localDumpsKey -Name "DumpFolder" -Value $customDumpFolder
Set-ItemProperty -Path $localDumpsKey -Name "DumpCount" -Value 10  # Keep up to 10 dump files
Set-ItemProperty -Path $localDumpsKey -Name "DumpType" -Value 2    # Full dump (2), Mini-dump (1)

Write-Host "Dump settings applied for all applications. Dumps will be saved to $customDumpFolder."

# Optionally set the crash dump location specifically for Visual Studio (devenv.exe)
$devenvDumpKey = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\devenv.exe"

# Check if the devenv.exe specific key exists, if not, create it
if (-not (Test-Path $devenvDumpKey)) {
    Write-Host "Creating devenv.exe specific LocalDumps registry key..."
    New-Item -Path $devenvDumpKey | Out-Null
    Write-Host "devenv.exe LocalDumps key created."
}

# Set the DumpFolder to the custom location for devenv.exe crashes
Set-ItemProperty -Path $devenvDumpKey -Name "DumpFolder" -Value $customDumpFolder
Set-ItemProperty -Path $devenvDumpKey -Name "DumpCount" -Value 10  # Keep up to 10 dump files
Set-ItemProperty -Path $devenvDumpKey -Name "DumpType" -Value 2    # Full dump (2), Mini-dump (1)

Write-Host "Dump settings applied for devenv.exe. Dumps will be saved to $customDumpFolder."
