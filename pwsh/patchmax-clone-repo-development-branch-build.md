
# PowerShell Script for Replicating GitHub Action Locally

## Overview

This PowerShell script is designed to replicate a GitHub Action locally by creating a temporary build environment. It clones the necessary repositories, sets up `vcpkg`, and builds the project using MSBuild. The output files (e.g., `.exe`, `.dll`, `.lib`) are copied to a designated output directory.

## Script Functionality

- Creates a temporary directory for the build process.
- Clones the `vcpkg` and `PatchIccMAX` repositories.
- Sets up `vcpkg` and installs required packages.
- Builds the `PatchIccMAX` project using MSBuild.
- Copies `.exe`, `.dll`, and `.lib` files to the output directory.
- Optionally cleans up the temporary directory after the build process.

## Prerequisites

1. Ensure that PowerShell 5.0 or higher is installed.
2. Git must be installed and accessible from the command line.
3. MSBuild from Visual Studio 2022 Build Tools must be installed. Update the path to MSBuild in the script if necessary.
4. Internet access to clone repositories and install vcpkg packages.

## How to Use

1. **Edit the script**: Update paths like `$msbuildPath`, `$vcpkgDir`, and `$baseDir` if necessary.
2. **Run the script**: Open PowerShell and execute the script. It will handle the rest, including the cloning, setup, and building of the project.

### Example of the script:

```powershell
# Create a temporary directory for the build process
$tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $tempDir -Force

# Set up paths within the temp directory
$baseDir = "$tempDir\DemoIccMAXBuild"
$vcpkgDir = "$baseDir\vcpkg"
$patchDir = "$baseDir\patch"
$outputDir = "$baseDir\output"

# Create necessary directories
New-Item -ItemType Directory -Path $baseDir -Force
New-Item -ItemType Directory -Path $outputDir -Force

# Clone and setup vcpkg
if (-not (Test-Path "$vcpkgDir")) {
    git clone https://github.com/microsoft/vcpkg.git $vcpkgDir
}
cd $vcpkgDir
if (-not (Test-Path ".\vcpkg.exe")) {
    .\bootstrap-vcpkg.bat
}
.\vcpkg.exe integrate install
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows

# Clone DemoIccMAX repository and apply patch
cd $baseDir
if (-not (Test-Path "$baseDir\PatchIccMAX")) {
    git clone https://github.com/xsscx/PatchIccMAX.git
}
cd "$baseDir\PatchIccMAX"
git checkout development

# Verify and display the directory contents
$solutionPath = "$baseDir\PatchIccMAX\Build\MSVC\BuildAll_v22.sln"
if (!(Test-Path $solutionPath)) {
    Write-Error "Solution file does not exist: $solutionPath"
    Get-ChildItem -Path "$baseDir\PatchIccMAX\Build\MSVC"
    exit 1
} else {
    Write-Host "Solution file exists at: $solutionPath"
}

# Build the project
$msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
$buildDir = "$baseDir\PatchIccMAX"
cd $buildDir
& $msbuildPath /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /DEBUG /INCREMENTAL:NO"

# List files in the build directory before search
$directory = "$baseDir\PatchIccMAX"
Write-Host "Listing files before search:"
Get-ChildItem -Path $directory -Recurse | Write-Host

# Search for .exe, .dll, and .lib files and copy them to the output directory
$files = Get-ChildItem -Path $directory -Recurse -Include *.exe, *.dll, *.lib
foreach ($file in $files) {
    Copy-Item -Path $file.FullName -Destination $outputDir
}

# List files in the output directory
Write-Host "Listing files in the output directory:"
Get-ChildItem -Path $outputDir | Write-Host

# Optionally clean up the temporary directory after the build
# Remove-Item -Recurse -Force $tempDir
```

## Notes

- Ensure that the paths for MSBuild and other tools are correct for your environment.
- Always verify the solution path and make sure the required `.sln` file exists before proceeding with the build.
