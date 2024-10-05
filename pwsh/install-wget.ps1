# Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Restart the script with elevated privileges
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    exit
}

# Set the download URL and destination path
$WGET_URL = "https://eternallybored.org/misc/wget/current/wget.exe"
$WGET_DEST = "$env:ProgramFiles\wget"

# Create the destination directory if it doesn't exist
if (-not (Test-Path $WGET_DEST)) {
    New-Item -ItemType Directory -Path $WGET_DEST
}

# Download wget using PowerShell
Write-Output "Downloading wget..."
Invoke-WebRequest -Uri $WGET_URL -OutFile "$WGET_DEST\wget.exe"

# Add wget to the PATH environment variable for the current session
$env:PATH = "$WGET_DEST;$env:PATH"

# Verify installation
& "$WGET_DEST\wget.exe" --version

if ($?) {
    Write-Output "wget was installed successfully."
} else {
    Write-Output "Failed to install wget."
}
