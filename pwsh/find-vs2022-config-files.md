
# PowerShell Script to Scan for Project and Configuration Files

This PowerShell script recursively scans a directory for project-related files, including `.vcxproj`, `.sln`, `.vcproj`, `.filters`, `.props`, `.json`, `.config`, `.yml`, and `.cmake` files. It outputs the full paths of all matching files, providing a quick way to locate important configuration or project files in large repositories.

## PowerShell Script

```powershell
Get-ChildItem -Recurse -File | Where-Object { $_.Extension -match '(\.vcxproj|\.sln|\.vcproj|\.filters|\.props|\.json|\.config|\.yml|\.cmake)' } | ForEach-Object { Write-Host "Found: $($_.FullName)" }
```

## Script Breakdown

1. **Recursive File Search**:  
   The script uses the `Get-ChildItem` cmdlet with the `-Recurse` and `-File` parameters to search all subdirectories starting from the current directory. It looks for files, ensuring that no directories are included in the output.

2. **File Extension Filter**:  
   The `Where-Object` cmdlet filters the results by matching specific file extensions using a regular expression:
   - `.vcxproj`, `.sln`, `.vcproj`: Visual Studio project and solution files.
   - `.filters`, `.props`: Additional Visual Studio configuration files.
   - `.json`, `.config`: Common configuration files.
   - `.yml`: YAML files typically used for CI/CD pipelines and other configuration tasks.
   - `.cmake`: CMake build system files.

3. **Output the Results**:  
   For each file that matches the specified extensions, the script uses `Write-Host` to print the full file path to the console.

## Usage Instructions

1. **Run the Script**:  
   Open PowerShell in the root directory of your project, and run the script. It will scan all subdirectories and list any project or configuration files it finds.

2. **Customizing File Extensions**:  
   If you need to search for other file types, simply modify the regular expression in the `Where-Object` block. For example, to include `.xml` files, you can add `|\.xml` to the existing regular expression.

3. **Search a Specific Directory**:  
   By default, the script searches from the current directory. If you'd like to specify a different root directory, modify the `Get-ChildItem` call like this:
   ```powershell
   Get-ChildItem -Path "C:\path\to\your\directory" -Recurse -File | Where-Object { $_.Extension -match '(\.vcxproj|\.sln|\.vcproj|\.filters|\.props|\.json|\.config|\.yml|\.cmake)' } | ForEach-Object { Write-Host "Found: $($_.FullName)" }
   ```

## Important Notes

- This script is optimized for use in environments where you're working with Visual Studio projects, build configurations, and other related tools.
- The output of the script can be easily piped into other cmdlets or redirected to a file for further processing. For example, to save the output to a text file:
   ```powershell
   Get-ChildItem -Recurse -File | Where-Object { $_.Extension -match '(\.vcxproj|\.sln|\.vcproj|\.filters|\.props|\.json|\.config|\.yml|\.cmake)' } | ForEach-Object { Write-Host "Found: $($_.FullName)" } > project_files_list.txt
   ```

