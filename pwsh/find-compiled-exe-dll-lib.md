
# PowerShell Script to Scan for `.dll` and `.lib` Files

This PowerShell script scans a specified directory (and its subdirectories) for `.dll` and `.lib` files. It removes duplicate entries based on their full paths, sorts the results, and outputs the unique file paths.

## PowerShell Script

```powershell
# Define the root directory to scan
$rootDir = "C:\tmp\PatchIccMAX\"

# Scan for .dll and .lib files in the root directory and subdirectories
$sourceFiles = Get-ChildItem -Path $rootDir -Recurse -Include *.dll, *.lib

# Remove duplicates based on FullName and sort by FullName
$uniqueFiles = $sourceFiles | Sort-Object -Property FullName -Unique

# Output the full paths of the unique .lib and .dll files
Write-Host "Unique .lib and .dll files with full paths:"
$uniqueFiles | Sort-Object -Property FullName | ForEach-Object {
    Write-Host $_.FullName
}
```

## Script Breakdown

1. **Directory Definition**:  
   The script starts by defining the root directory to scan for `.dll` and `.lib` files. You can modify the `$rootDir` variable to point to the directory you want to scan.

2. **File Scanning**:  
   It uses the `Get-ChildItem` cmdlet with the `-Recurse` flag to recursively search the directory for files with the `.dll` or `.lib` extensions.

3. **Removing Duplicates and Sorting**:  
   The `Sort-Object` cmdlet is used to sort the files by their full paths and ensure uniqueness. Any duplicate files based on the full path are removed.

4. **Outputting the Results**:  
   The script outputs the full paths of the unique `.dll` and `.lib` files to the console using `Write-Host`.

## Usage Instructions

1. **Set the Correct Directory**:  
   Modify the `$rootDir` variable to point to the directory where you want to scan for `.dll` and `.lib` files.

2. **Run the Script**:  
   Open PowerShell and run the script. The script will search the specified directory and print the full paths of all unique `.dll` and `.lib` files to the console.

## Important Notes

- The script only searches for files with the `.dll` and `.lib` extensions. If you need to include other file types, you can modify the `-Include` parameter in the `Get-ChildItem` cmdlet.
- Ensure you have sufficient permissions to access the directories and files that the script is scanning.

