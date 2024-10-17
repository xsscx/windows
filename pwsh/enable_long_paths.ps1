# Check if running as Administrator
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Registry path for enabling long paths
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
$propertyName = "LongPathsEnabled"
$propertyValue = 1

# Check if the key exists
if (-Not (Test-Path $registryPath)) {
    Write-Host "Registry path not found. Please check your system configuration." -ForegroundColor Red
    exit
}

# Set the LongPathsEnabled value to 1 (enable)
try {
    Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue
    Write-Host "Long path support has been enabled successfully." -ForegroundColor Green
} catch {
    Write-Host "Failed to enable long path support: $($_.Exception.Message)" -ForegroundColor Red
}

# Verify the setting
$currentValue = Get-ItemProperty -Path $registryPath -Name $propertyName
if ($currentValue.$propertyName -eq $propertyValue) {
    Write-Host "The LongPathsEnabled setting is now set to: $($currentValue.$propertyName)" -ForegroundColor Green
} else {
    Write-Host "There was an issue applying the setting. Please verify manually." -ForegroundColor Yellow
}
