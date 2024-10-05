
# PowerShell Script for Reinstalling vcpkg Packages

## Overview

This PowerShell script is designed to help you reinstall specific packages using the vcpkg package manager. The script ensures that the selected packages are installed with the required features and marked as editable.

## Script Functionality

- Sets the path to `vcpkg.exe`.
- Reinstalls a list of packages with specific features, including recursive dependencies.
- Notifies the user during the installation process.

## Prerequisites

1. Ensure that vcpkg is installed and the path to `vcpkg.exe` is correct in the script.
2. PowerShell 5.0 or higher.
3. Administrator privileges might be required to run the script, depending on your environment.

## How to Use

1. **Edit the script**: Update the `$vcpkgDir` variable to reflect the actual path where `vcpkg.exe` is installed.
2. **Define packages**: The list of packages to install is set in the `$packagesToInstall` array. You can add, remove, or modify the packages as needed.
3. **Run the script**: Open PowerShell and run the script in the directory where your `vcpkg` is installed.

### Example of the script:

```powershell
# Set the path to vcpkg
$vcpkgDir = "C:\tmp\vcpkg-master\vcpkg-master\"
$vcpkgExe = "$vcpkgDir\vcpkg.exe"

# Reinstall the packages with the required features to ensure they're marked for export
$packagesToInstall = @(
    "libxml2[iconv,lzma,zlib]:x64-windows",
    "tiff[jpeg,lzma,zip]:x64-windows",
    "pcre2[jit,platform-default-features]:x64-windows",
    "wxwidgets[debug-support,sound]:x64-windows"
)

# Reinstall the packages
foreach ($package in $packagesToInstall) {
    $vcpkgInstallCommand = "$vcpkgExe install $package --recurse --editable"
    Write-Host "Reinstalling package: $package"
    Invoke-Expression $vcpkgInstallCommand
}
```

## Notes

- This script does not include error handling for failed package installations. It's recommended to monitor the output for any issues.
- Make sure the `vcpkg` installation directory and the packages you intend to install are correct before running the script.
