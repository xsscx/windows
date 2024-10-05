
# Get-SymlinkTargetDirectory PowerShell Function

This PowerShell function, `Get-SymlinkTargetDirectory`, retrieves the target directory of a symbolic link on Windows.

## Function Overview

- **Input**: The function accepts a single parameter:
  - `$SymlinkDir`: The path to the symbolic link directory whose target you want to retrieve.
- **Process**: 
  - The function extracts the base path and folder name from the provided symbolic link path.
  - It then uses the `cmd /c dir /a:l` command to list directory details with symbolic link attributes.
  - A regular expression is applied to extract the target directory of the symbolic link.
- **Output**: 
  - If the symbolic link is valid and the target is found, it returns the path of the target directory.
  - If no target is found, it returns an empty string.

## Usage

To use this function in a PowerShell script or session:

1. Open PowerShell.
2. Define the function by pasting the code into your session or saving it in a script.
3. Call the function with the path to the symbolic link directory:

```powershell
$targetDir = Get-SymlinkTargetDirectory -SymlinkDir "C:\path\to\symlink"
Write-Output $targetDir
```

## Example

Suppose you have a symbolic link at `C:\MyLink` that points to `D:\TargetDirectory`. You can retrieve the target as follows:

```powershell
$targetDir = Get-SymlinkTargetDirectory -SymlinkDir "C:\MyLink"
Write-Output $targetDir
```

This will output:

```
D:\TargetDirectory
```

## Requirements

- Windows OS
- PowerShell
