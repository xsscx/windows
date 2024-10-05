# Source directory where vcpkg packages are located
$sourceDir = "C:\tmp\Build\vcpkg\packages"

# Target directory where DLLs should be copied
$targetDir = "C:\gits-repo-sept14\PatchIccMAX\Testing"

# Ensure the target directory exists (create if it doesn't)
if (-not (Test-Path -Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir
}

# Copy all .dll files from the subdirectories in $sourceDir to $targetDir
Get-ChildItem -Path $sourceDir -Recurse -Filter *.dll | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $targetDir -Force
}

Write-Host "All DLL files have been copied to $targetDir"
