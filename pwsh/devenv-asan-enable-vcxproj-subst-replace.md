
# PowerShell Script to Update `.vcxproj` Files

## Overview

This PowerShell script recursively scans a specified directory for Visual Studio `.vcxproj` project files and ensures that the `<EnableASAN>` element is either created or updated to `false`. It is designed to automate the process of configuring AddressSanitizer (ASAN) settings across multiple project files.

## Features

- Searches for all `.vcxproj` files in the specified directory and its subdirectories.
- Adds the `<EnableASAN>` element with the value `false` if it does not exist.
- Updates the `<EnableASAN>` element to `false` if it already exists.
- Saves the changes to the `.vcxproj` files and provides a summary of the updated files.

## Requirements

- PowerShell 5.1 or higher
- Windows operating system
- Access to the directory containing the `.vcxproj` files

## Usage

1. Clone or download the repository containing the script.
2. Modify the `$rootDir` variable in the script to point to your project directory. Replace the following line:
   ```powershell
   $rootDir = "C:\tmp\export"  # Replace with the actual path to your project
   ```
3. Open PowerShell and run the script:
   ```powershell
   .\devenv-asan-enable-vcxproj-subst-replace.ps1.ps1
   ```

4. The script will output the list of `.vcxproj` files that have been updated.

## Notes

- Ensure that you have write permissions to the `.vcxproj` files before running the script.
- Make a backup of your project files before running any automated scripts to prevent accidental loss of data.
