# Define the root directory to scan
$rootDir = "C:\gits-repo-sept14\PatchIccMAX\"

# Scan for .dll and .lib files in the root directory and subdirectories
$sourceFiles = Get-ChildItem -Path $rootDir -Recurse -Include *.dll, *.lib

# Remove duplicates based on FullName and sort by FullName
$uniqueFiles = $sourceFiles | Sort-Object -Property FullName -Unique

# Output the full paths of the unique .lib and .dll files
Write-Host "Unique .lib and .dll files with full paths:"
$uniqueFiles | Sort-Object -Property FullName | ForEach-Object {
    Write-Host $_.FullName
}
