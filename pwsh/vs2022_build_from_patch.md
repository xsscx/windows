
# Building and Patching IccMAX with vcpkg and MSBuild

This PowerShell script automates the process of setting up the build environment for the IccMAX project, downloading necessary dependencies via `vcpkg`, applying patches, and building the project using MSBuild.

## Prerequisites

- Windows machine with PowerShell.
- Administrator privileges to create directories and run build processes.
- Git installed.
- Microsoft Visual Studio 2022 installed, with MSBuild.
- Internet connection to clone repositories and download dependencies.

## Setup Steps

### 1. Set Up Base and Working Directories

The following paths are set up in the script:
- `$baseDir`: The base directory for the build process. In this example, it is set to `C:\tmp\build`.
- `$repoDir`: Directory where the `PatchIccMAX` repository is cloned.
- `$vcpkgDir`: Directory where the `vcpkg` tool is cloned.
- `$patchDir`: Directory for patch-related files.

### 2. Create Base Directory

```powershell
New-Item -ItemType Directory -Path $baseDir -Force
```

This command creates the base directory (`C:\tmp\build`) where all operations will take place.

### 3. Clone and Setup vcpkg

The script clones the `vcpkg` repository from GitHub and installs the necessary dependencies (`libxml2`, `tiff`, and `wxwidgets`) for x64 architecture:

```bash
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.bat
./vcpkg.exe integrate install
./vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows
```

### 4. Clone and Apply Patches to DemoIccMAX

The script clones the `PatchIccMAX` repository and applies a specific patch to the build:

```bash
git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
git revert --no-edit b90ac3933da99179df26351c39d8d9d706ac1cc6
git apply contrib/Research/vs2022-build-mods.patch
```

### 5. Build the Solution using MSBuild

The path to MSBuild is defined based on the Visual Studio installation:

```powershell
$msbuildPath = "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
```

The script then uses MSBuild to compile the solution with the following command:

```powershell
& "$msbuildPath" /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64
```

### 6. Verbose Build with Additional Options

For a more detailed build process with verbose output and additional compiler and linker options, the script can be run with the following command:

```powershell
& $msbuildPath /m /maxcpucount /v:diag .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /Zi /Od /DDEBUG /W4 /GS /RTC1 /sdl /MP" /p:LinkToolAdditionalOptions="/fsanitize=address /DEBUG /INCREMENTAL:NO /NXCOMPAT /DYNAMICBASE /LTCG" /t:Build
```

### 7. Minimized Debug Build with Address Sanitizer

For a minimized debug build with address sanitizer (`asan`) enabled:

```powershell
& $msbuildPath /m /maxcpucount /v:minimal .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /Zi /Od /DDEBUG /W4 /GS /RTC1 /sdl /MP" /p:LinkToolAdditionalOptions="/fsanitize=address /DEBUG /INCREMENTAL:NO /NXCOMPAT /DYNAMICBASE /LTCG" /t:Build
```

## Summary of Build Options

- **Verbose Build**: This mode shows detailed diagnostic output for debugging purposes, providing information on every step of the build process.
- **Minimized Debug Build**: This is a more compact build output focused on debug configuration and includes the address sanitizer to help catch memory-related issues.
