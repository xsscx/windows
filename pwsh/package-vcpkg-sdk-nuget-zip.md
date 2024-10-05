
# PowerShell Script for Exporting Packages using vcpkg

## Overview

This PowerShell script automates the process of exporting packages managed by `vcpkg` in three different formats: SDK, NuGet package, and ZIP file. It allows users to easily export vcpkg packages for distribution or use in different environments.

## Script Functionality

1. **SDK Export**:
    - Exports the vcpkg packages as a raw SDK to a specified directory (`C:\tmp\sdk`).
  
2. **NuGet Package Export**:
    - Exports the vcpkg packages as a NuGet package to a specified directory (`C:\tmp\nuget`).
  
3. **ZIP File Export**:
    - Exports the vcpkg packages as a ZIP file to a specified directory (`C:\tmp\zip`).

4. **Completion**:
    - Outputs a message to the console after each export is completed, and a final message when all exports are successful.

## Prerequisites

- **vcpkg**: Ensure that `vcpkg` is installed and the path to `vcpkg.exe` is correctly set in your environment.
- **PowerShell Version**: Ensure PowerShell 5.0 or higher is installed.
- **Export Directories**: Make sure the directories (`C:\tmp\sdk`, `C:\tmp\nuget`, and `C:\tmp\zip`) exist or will be created by the script.

## How to Use

1. **Edit the script** (optional):
    - If needed, modify the export directories (`$exportDirSDK`, `$exportDirNuGet`, `$exportDirZip`) to point to your desired locations.
  
2. **Run the script**:
    - Open PowerShell with the necessary permissions and execute the script.
    - The script will export the vcpkg packages into the three formats (SDK, NuGet, and ZIP) and store them in the specified directories.

3. **Verify the Output**:
    - After running the script, check the directories to ensure that the exported SDK, NuGet package, and ZIP file have been created.

### Example of the script:

```powershell
# Export to SDK
$exportDirSDK = "C:\tmp\sdk"  # Define the directory where the SDK will be exported
$vcpkgCommandSDK = "$vcpkgExe export --output=$exportDirSDK --triplet=x64-windows --raw"
Write-Host "Exporting packages as SDK..."
Invoke-Expression $vcpkgCommandSDK

# Export to NuGet package
$exportDirNuGet = "C:\tmp\nuget"  # Define the directory where the NuGet package will be exported
$vcpkgCommandNuGet = "$vcpkgExe export --output=$exportDirNuGet --nuget --triplet=x64-windows"
Write-Host "Exporting packages as NuGet package..."
Invoke-Expression $vcpkgCommandNuGet

# Export to ZIP file
$exportDirZip = "C:\tmp\zip"  # Define the directory where the ZIP will be exported
$vcpkgCommandZip = "$vcpkgExe export --output=$exportDirZip --zip --triplet=x64-windows"
Write-Host "Exporting packages as ZIP file..."
Invoke-Expression $vcpkgCommandZip

Write-Host "All exports completed successfully."
```

