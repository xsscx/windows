# Path to the Windows Terminal settings.json file
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Read the current settings.json
$settingsJson = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json

# Set Developer PowerShell as the default profile by GUID
$settingsJson.defaultProfile = "{ee9427ca-a2a1-5100-9ed5-f4e53ffbce9b}"

# Write the changes back to settings.json
$settingsJson | ConvertTo-Json -Depth 32 | Set-Content -Path $settingsPath
