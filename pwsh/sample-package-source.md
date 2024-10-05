
# PowerShell Script for Packaging DemoIccMAX Project

## Overview

This PowerShell script automates the process of copying files from a DemoIccMAX project directory to a package directory. It organizes executables, libraries, include files, and other necessary files into respective subdirectories within the destination package directory. The script ensures that all required files are properly packaged for distribution.

## Script Functionality

1. **Directory Setup**:
    - Defines the root directory of the DemoIccMAX project (`$rootDir`) and the destination package directory (`$destDir`).
    - Checks if the destination directory exists. If not, it creates the necessary directory structure.

2. **Subdirectories**:
    - Creates the following subdirectories within the package directory:
        - `bin`: For executable files.
        - `lib`: For dynamic link library (DLL) and static library (LIB) files.
        - `include`: For header and include files.
        - `other`: For any other necessary files (e.g., configuration, data files).

3. **File Copying with Logging**:
    - A function `Copy-WithLogging` is used to copy files from the source to the destination, logging success or failure.
    
4. **Copy Specific File Types**:
    - Copies the following types of files from the project directory:
        - `.exe`: Executables (only from Debug directories).
        - `.dll`: Dynamic link library files.
        - `.lib`: Static library files.
        - Include files from the `include` subdirectory.
        - Other necessary files from specific subdirectories like `Testing` and `Tools`.

5. **Completion**:
    - Outputs a message indicating that the packaging process is complete and the files have been copied to the destination directory.

## Prerequisites

- **PowerShell Version**: Ensure PowerShell 5.0 or higher is installed.
- **Directory Paths**: Make sure that the `$rootDir` and `$destDir` variables are correctly set to the paths where the project and destination directories are located.

## How to Use

1. **Edit the script**: 
    - Update `$rootDir` and `$destDir` with the correct paths for your project and destination directories.
    - Modify the file paths in the `Get-ChildItem` commands if needed to match the structure of your project.

2. **Run the script**: 
    - Open PowerShell with the necessary permissions and execute the script.

3. **Verify the Output**: 
    - Check the destination directory (`$destDir`) to ensure that all files have been copied into their respective subdirectories.

### Example of the script:

```powershell
# Define the root directory of the DemoIccMAX Project and the destination package directory
$rootDir = "C:\opt\DemoIccMAX"
$destDir = "C:\opt\package"

# Ensure the destination directory exists
if (-Not (Test-Path -Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir
}

# Define subdirectories for binaries, libraries, and other necessary files
$binDir = Join-Path -Path $destDir -ChildPath "bin"
$libDir = Join-Path -Path $destDir -ChildPath "lib"
$includeDir = Join-Path -Path $destDir -ChildPath "include"
$otherDir = Join-Path -Path $destDir -ChildPath "other"

# Create subdirectories in the package directory
New-Item -ItemType Directory -Path $binDir
New-Item -ItemType Directory -Path $libDir
New-Item -ItemType Directory -Path $includeDir
New-Item -ItemType Directory -Path $otherDir

# Function to copy files with logging
function Copy-WithLogging {
    param (
        [string]$sourcePath,
        [string]$destinationPath
    )
    
    Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    if ($?) {
        Write-Output "Copied: $sourcePath to $destinationPath"
    } else {
        Write-Output "Failed to copy: $sourcePath"
    }
}

# Copy executable files from Debug directories
Get-ChildItem -Path $rootDir -Filter *.exe -Recurse | ForEach-Object {
    if ($_.FullName -like "*Debug*") {
        Copy-WithLogging $_.FullName $binDir
    }
}

# Copy dynamic link library files (DLLs)
Get-ChildItem -Path $rootDir -Filter *.dll -Recurse | ForEach-Object {
    Copy-WithLogging $_.FullName $libDir
}

# Copy static library files (LIBs)
Get-ChildItem -Path $rootDir -Filter *.lib -Recurse | ForEach-Object {
    Copy-WithLogging $_.FullName $libDir
}

# Copy include files
Get-ChildItem -Path $rootDir\include -Filter *.* -Recurse | ForEach-Object {
    Copy-WithLogging $_.FullName $includeDir
}

# Copy other necessary files (e.g., config, data)
Get-ChildItem -Path $rootDir\Testing -Filter *.* -Recurse | ForEach-Object {
    Copy-WithLogging $_.FullName $otherDir
}

# Optional: Copy specific data files from DataSetFiles or other directories
Get-ChildItem -Path $rootDir\Tools\IccApplyNamedCmm\DataSetFiles -Filter *.* -Recurse | ForEach-Object {
    Copy-WithLogging $_.FullName $otherDir
}

Write-Output "Packaging completed. Files have been copied to $destDir"
```
