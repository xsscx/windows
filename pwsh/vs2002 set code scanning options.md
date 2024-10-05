
# PowerShell Script to Modify vcxproj Files

## Overview

This PowerShell script is designed to recursively find all `.vcxproj` files in a directory and replace the XML tag `<RunCodeAnalysis>true</RunCodeAnalysis>` with `<RunCodeAnalysis>false</RunCodeAnalysis>`. This can be useful in scenarios where you want to disable code analysis for multiple projects in a Visual Studio solution.

## Usage

1. Copy the script into your PowerShell environment.
2. Run the script from the root directory where your `.vcxproj` files are located.

### Example:

```powershell
Get-ChildItem -Recurse -Filter *.vcxproj | ForEach-Object {
    (Get-Content $_.FullName) -replace '<RunCodeAnalysis>true</RunCodeAnalysis>', '<RunCodeAnalysis>false</RunCodeAnalysis>' | Set-Content $_.FullName
}
```

This script does the following:
- Recursively searches for all files ending with `.vcxproj`.
- Reads the content of each file.
- Replaces the `<RunCodeAnalysis>true</RunCodeAnalysis>` tag with `<RunCodeAnalysis>false</RunCodeAnalysis>`.
- Saves the modified content back to the original file.

## Prerequisites

- PowerShell 5.0 or higher.
- Ensure that you have appropriate permissions to modify the files in the directory.

## Notes

- **Backup your files**: It's recommended to backup your `.vcxproj` files before running this script.
- The script modifies files in place, so no temporary files are created.
- Make sure that the target tag exists in the `.vcxproj` files before running this script.


