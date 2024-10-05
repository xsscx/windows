# Set the system crash dump type to Complete Memory Dump

# Define the custom crash dump directory (F:\crash or where...)
$systemDumpFolder = "F:\crash"

# Check if the custom crash dump folder exists, if not, create it
if (-not (Test-Path $systemDumpFolder)) {
    Write-Host "Creating system crash dump directory at $systemDumpFolder..."
    New-Item -Path $systemDumpFolder -ItemType Directory | Out-Null
    Write-Host "Directory created."
} else {
    Write-Host "System crash dump directory already exists at $systemDumpFolder."
}

# Set the registry path for system crash dump configuration
$systemKey = "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl"

# Set the dump type to Complete Memory Dump (value 1)
Set-ItemProperty -Path $systemKey -Name "CrashDumpEnabled" -Value 1

# Configure the dump file location to F:\crash\MEMORY.DMP
Set-ItemProperty -Path $systemKey -Name "DumpFile" -Value "$systemDumpFolder\MEMORY.DMP"

# Set Overwrite to 1 (to overwrite existing dump files when a new crash occurs)
Set-ItemProperty -Path $systemKey -Name "Overwrite" -Value 1

# Disable automatic restart after a system crash (optional)
Set-ItemProperty -Path $systemKey -Name "AutoReboot" -Value 0

# Set Minidump folder location (if needed)
Set-ItemProperty -Path $systemKey -Name "MinidumpDir" -Value "$systemDumpFolder"

Write-Host "System crash dump settings updated. Complete memory dumps will be saved to $systemDumpFolder."
