# Define the root directory of the project and the destination package directory
$rootDir = "C:\Users\h0233\tmp\DemoIccMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6"
$destDir = "C:\Users\h0233\package"

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
# Assuming other necessary files are in specific subdirectories; modify paths as needed
Get-ChildItem -Path $rootDir\Testing -Filter *.* -Recurse | ForEach-Object {
    Copy-WithLogging $_.FullName $otherDir
}

# Optional: Copy specific data files from DataSetFiles or other directories
# Modify the following line to match the specific directory structure and files you need to include
Get-ChildItem -Path $rootDir\Tools\IccApplyNamedCmm\DataSetFiles -Filter *.* -Recurse | ForEach-Object {
    Copy-WithLogging $_.FullName $otherDir
}

Write-Output "Packaging completed. Files have been copied to $destDir"
