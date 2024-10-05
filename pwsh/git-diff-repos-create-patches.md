
# PowerShell Script to Compare Two Git Repositories and Generate Patch Files

This PowerShell script compares two Git repositories by cloning specific branches (`main` and `development`) and performing a file-by-file comparison of `.cpp` and `.h` files, excluding irrelevant directories such as `.git`. The script generates patch files for any differences and outputs a summary report.

## PowerShell Script

```powershell
# Define the repositories and branches to compare
$repo1Url = "https://github.com/xsscx/DemoIccMAX.git"
$repo2Url = "https://github.com/xsscx/PatchIccMAX.git"
$repo1Branch = "main"
$repo2Branch = "development"

# Create a temporary directory for the build process
$tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
Write-Output "Creating temporary directory: $tempDir"
New-Item -ItemType Directory -Path $tempDir -Force

# Define subdirectories for each repository within the temporary directory
$tempDir1 = [System.IO.Path]::Combine($tempDir, "DemoIccMAX")
$tempDir2 = [System.IO.Path]::Combine($tempDir, "PatchIccMAX")

# Clone the first repository
Write-Output "Cloning repository 1 from $repo1Url into $tempDir1"
git clone $repo1Url $tempDir1
cd $tempDir1
if (git rev-parse --verify --quiet $repo1Branch) {
    git checkout $repo1Branch
} else {
    Write-Output "Branch '$repo1Branch' does not exist in repository 1. Using the default branch."
}

# Clone the second repository
Write-Output "Cloning repository 2 from $repo2Url into $tempDir2"
git clone $repo2Url $tempDir2
cd $tempDir2
if (git rev-parse --verify --quiet $repo2Branch) {
    git checkout $repo2Branch
} else {
    Write-Output "Branch '$repo2Branch' does not exist in repository 2. Using the default branch."
}

# Create a directory to store the patch files
$patchDir = ".\patch"
Write-Output "Creating patch directory: $patchDir"
New-Item -ItemType Directory -Path $patchDir -Force

# Get all .cpp and .h files in the first repository, excluding irrelevant directories
$filesRepo1 = Get-ChildItem -Recurse -Path $tempDir1 -Include *.cpp, *.h | Where-Object { $_.FullName -notmatch '\\.git\\' }
Write-Output "Found $($filesRepo1.Count) .cpp and .h files in the first repository"

# Compare each corresponding file in the two repositories
foreach ($file1 in $filesRepo1) {
    # Construct the relative path correctly
    $relativePath = $file1.FullName.Substring($tempDir1.Length).TrimStart('\')

    # Construct the full path for the corresponding file in repo2
    $file2Path = [System.IO.Path]::Combine($tempDir2, $relativePath)
    
    Write-Output "Comparing files:"
    Write-Output "Repo 1: $($file1.FullName)"
    Write-Output "Repo 2: $file2Path"

    if (Test-Path $file2Path) {
        # Perform the diff and capture the output
        $diffOutput = git diff --no-index "$($file1.FullName)" "$file2Path"

        if ($diffOutput) {
            # Write the diff to a .patch file
            $patchFileName = $relativePath.Replace("\", "_") + ".patch"
            $patchFilePath = [System.IO.Path]::Combine($patchDir, $patchFileName)
            $diffOutput | Out-File -FilePath $patchFilePath -Encoding utf8

            Write-Output "Patch file created: $patchFilePath"
        } else {
            Write-Output "No differences found for $relativePath"
        }
    } else {
        Write-Output "File $relativePath does not exist in repository 2"
    }
}

# Get a summary of differences excluding irrelevant files and directories
$filesForSummary = $filesRepo1 | ForEach-Object { 
    $relativePath = $_.FullName.Substring($tempDir1.Length).TrimStart('\')
    $file2Path = [System.IO.Path]::Combine($tempDir2, $relativePath)
    if (Test-Path $file2Path) { 
        git diff --summary --no-index $_.FullName $file2Path 
    }
}

$diffOutput = $filesForSummary | Out-String

# Define the output file for the diff report
$reportFile = [System.IO.Path]::Combine($tempDir, "DiffReport.txt")

# Write the formatted report to the file
$reportContent = @"
=== Diff Report ===
Repository 1: $repo1Url (Branch: $repo1Branch)
Repository 2: $repo2Url (Branch: $repo2Branch)

--- Diff Summary ---
$diffOutput
"@

$reportContent | Out-File -FilePath $reportFile -Encoding UTF8

# Display the path to the report file
Write-Output "Diff report has been generated and saved to: $reportFile"

# Optional: Clean up the temporary directory
# Write-Output "Cleaning up temporary directory: $tempDir"
# Remove-Item -Recurse -Force $tempDir
```

## Script Breakdown

1. **Repository and Branch Definition**:  
   The script defines two repositories and specifies branches to compare (`main` for the first repo and `development` for the second). If a branch doesn’t exist, the default branch is used.

2. **Temporary Directory Creation**:  
   A temporary directory is created to store the cloned repositories, providing isolation for the comparison process.

3. **Repository Cloning and Branch Checkout**:  
   The script clones both repositories and checks out the specified branches (`main` and `development`).

4. **File Comparison**:  
   The script searches for `.cpp` and `.h` files in the first repository, excluding irrelevant directories like `.git`. It compares each file to the corresponding file in the second repository.

5. **Generating Patch Files**:  
   For every file that differs, a `.patch` file is created and saved in a `patch` directory.

6. **Generating a Diff Report**:  
   The script generates a summary of differences and writes the report to `DiffReport.txt` in the temporary directory.

## Usage Instructions

1. **Run the Script**:  
   Open PowerShell and run the script. Ensure Git is installed and available in your system’s PATH. The script will clone the repositories, compare files, and generate patch files for any differences.

2. **Customizing Repository URLs or Branches**:  
   To compare different repositories or branches, modify the `$repo1Url`, `$repo2Url`, `$repo1Branch`, or `$repo2Branch` variables.

3. **Optional Cleanup**:  
   Uncomment the cleanup section at the end of the script to remove temporary directories after the comparison.

## Important Notes

- This script requires Git to be installed.
- The patch files are saved in a `patch` directory.
- The script can be extended to handle other file types by modifying the `Get-ChildItem` filters.
