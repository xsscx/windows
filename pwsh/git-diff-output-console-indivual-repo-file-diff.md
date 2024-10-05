
# PowerShell Script to Compare Two Git Repositories and Generate Patch Files

This PowerShell script compares two Git repositories by cloning specific branches and performing a file-by-file comparison of `.cpp` and `.h` files. The script generates a patch for each file that has differences and creates a comprehensive diff report.

## PowerShell Script

```powershell
# Define the repositories and branches to compare
$repo1Url = "https://github.com/xsscx/DemoIccMAX.git"
$repo2Url = "https://github.com/xsscx/PatchIccMAX.git"
$branchName = "development"

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
if (git rev-parse --verify --quiet $branchName) {
    git checkout $branchName
} else {
    Write-Output "Branch '$branchName' does not exist in repository 1. Using the default branch."
}

# Clone the second repository
Write-Output "Cloning repository 2 from $repo2Url into $tempDir2"
git clone $repo2Url $tempDir2
cd $tempDir2
if (git rev-parse --verify --quiet $branchName) {
    git checkout $branchName
} else {
    Write-Output "Branch '$branchName' does not exist in repository 2. Using the default branch."
}

# Create a directory to store the patch files
$patchDir = ".\patch"
Write-Output "Creating patch directory: $patchDir"
New-Item -ItemType Directory -Path $patchDir -Force

# Get all .cpp and .h files in the first repository
$filesRepo1 = Get-ChildItem -Recurse -Path $tempDir1 -Include *.cpp, *.h
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
            # Get the diff stats
            $diffStats = git diff --no-index --stat "$($file1.FullName)" "$file2Path"

            # Output the stats and diff to the console
            Write-Output "=== Stats Report for $relativePath ==="
            Write-Output $diffStats
            Write-Output "=== Detailed Diff for $relativePath ==="
            Write-Output $diffOutput
            Write-Output ""

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

# Perform the diff and get the output
$diffOutput = git diff --stat --no-index $tempDir1 $tempDir2
$summaryOutput = git diff --summary --no-index $tempDir1 $tempDir2

# Define the output file for the diff report
$reportFile = [System.IO.Path]::Combine($tempDir, "DiffReport.txt")

# Write the formatted report to the file
$reportContent = @"
=== Diff Report ===
Repository 1: $repo1Url (Branch: $branchName)
Repository 2: $repo2Url (Branch: $branchName)

--- Diff Stats ---
$diffOutput

--- Diff Summary ---
$summaryOutput
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
   The script defines the URLs for the two repositories and specifies the branch to compare (`development`). If the branch doesn't exist, the default branch is used.

2. **Temporary Directory Creation**:  
   The script creates a temporary directory to store the cloned repositories and to manage the comparison process.

3. **Repository Cloning and Branch Checkout**:  
   Each repository is cloned into its own subdirectory within the temporary directory. The script checks out the specified branch if it exists.

4. **File Comparison**:  
   The script recursively searches for all `.cpp` and `.h` files in the first repository, and compares each corresponding file in the second repository. If differences are found, a patch file is generated.

5. **Generating a Diff Report**:  
   The script generates a detailed diff report, which includes file stats and a summary. This report is saved to the temporary directory as `DiffReport.txt`.

6. **Patch File Creation**:  
   For every file that has differences, the script generates a `.patch` file and saves it in the `patch` directory.

## Usage Instructions

1. **Run the Script**:  
   Open PowerShell and run the script. Make sure Git is installed on your system and available in your PATH. The script will clone the repositories, compare the files, and generate patch files for any differences.

2. **Optional Cleanup**:  
   To clean up the temporary directories created during the comparison, uncomment the cleanup section at the end of the script.

3. **Modifying the Repositories or Branches**:  
   If you need to compare different repositories or branches, simply modify the `$repo1Url`, `$repo2Url`, and `$branchName` variables.

## Important Notes

- This script requires Git to be installed on the system.
- The patch files are saved in the `patch` directory within the current working directory.
- The script can be extended to handle other file types by modifying the `Get-ChildItem` filters.
