# PowerShell script to replicate the GitHub Action locally using a temporary directory

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
