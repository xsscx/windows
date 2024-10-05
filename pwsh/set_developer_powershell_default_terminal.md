
# PowerShell Script for Setting Default Profile in Windows Terminal

## Overview

This PowerShell script is designed to modify the `settings.json` file of Windows Terminal to set the Developer PowerShell as the default profile by its GUID.

## Script Functionality

- Defines the path to the `settings.json` file in Windows Terminal.
- Reads the current `settings.json` configuration.
- Sets the Developer PowerShell as the default profile by specifying its GUID.
- Writes the changes back to the `settings.json` file.

## Prerequisites

1. Ensure PowerShell 5.0 or higher is installed.
2. Modify the script if needed to match the correct GUID for your preferred profile.
3. Administrator privileges might be required depending on your system settings.

## How to Use

1. **Edit the script**: Ensure that the `$settingsPath` variable is correct and points to your Windows Terminal's `settings.json` file. The default path is based on standard Windows installation.
2. **Run the script**: Open PowerShell and run the script.

### Example of the script:

```powershell
# Path to the Windows Terminal settings.json file
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Read the current settings.json
$settingsJson = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json

# Set Developer PowerShell as the default profile by GUID
$settingsJson.defaultProfile = "{ee9427ca-a2a1-5100-9ed5-f4e53ffbce9b}"

# Write the changes back to settings.json
$settingsJson | ConvertTo-Json -Depth 32 | Set-Content -Path $settingsPath
```

## Notes

- Make sure to verify the GUID of the profile you want to set as the default. You can find the correct GUID in the `profiles` section of the `settings.json` file.
- Always back up your original `settings.json` file before running this script in case you want to revert the changes.
