
# PowerShell Script to Compare Two Git Repositories

This PowerShell script clones two Git repositories, checks out specified branches from each, and performs a directory diff between them (excluding the `.git` directories). It outputs the diff statistics and summary to the console. The script also provides an optional cleanup section to remove the temporary directories created during the process.

## PowerShell Script

```powershell
# Define the repositories and branches to compare
$repo1Url = "https://github.com/InternationalColorConsortium/DemoIccMAX.git"
$repo2Url = "https://github.com/xsscx/PatchIccMAX.git"
$repo1Branch = "PCS_Refactor"  # Branch in DemoIccMAX
$repo2Branch = "development"  # Branch in PatchIccMAX

# Create a temporary directory for the build process
$tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $tempDir -Force

# Define subdirectories for each repository within the temporary directory
$tempDir1 = [System.IO.Path]::Combine($tempDir, "DemoIccMAX")
$tempDir2 = [System.IO.Path]::Combine($tempDir, "PatchIccMAX")

# Function to clone a repo and checkout a specific branch
function Clone-RepoAndCheckoutBranch {
    param (
        [string]$repoUrl,
        [string]$localPath,
        [string]$branchName
    )
    
    # Clone the repository
    git clone --depth=1 $repoUrl $localPath

    # Navigate to the cloned repo directory
    Set-Location $localPath

    # Check if the branch exists
    $branches = git branch -r
    if ($branches -notcontains "origin/$branchName") {
        Write-Error "Branch '$branchName' not found in repository $repoUrl."
        return
    }

    # Checkout the specified branch
    git checkout $branchName
}

# Clone and checkout for the first repository (DemoIccMAX)
Clone-RepoAndCheckoutBranch -repoUrl $repo1Url -localPath $tempDir1 -branchName $repo1Branch

# Clone and checkout for the second repository (PatchIccMAX)
Clone-RepoAndCheckoutBranch -repoUrl $repo2Url -localPath $tempDir2 -branchName $repo2Branch

# Perform the diff by directly comparing the directories, excluding .git directories
$diffOutput = git diff --stat --no-index "$tempDir1" "$tempDir2" | Where-Object { $_ -notmatch ".git/" }
$summaryOutput = git diff --summary --no-index "$tempDir1" "$tempDir2" | Where-Object { $_ -notmatch ".git/" }

# Output the results to the console
Write-Output "`n--- Diff Stats ---`n"
Write-Output $diffOutput | Out-Host
Write-Output "`n--- Diff Summary ---`n"
Write-Output $summaryOutput | Out-Host

# Clean up the temporary directories
# Optional: If you want to clean up after the script runs, uncomment these lines
# Remove-Item -Recurse -Force $tempDir1
# Remove-Item -Recurse -Force $tempDir2
```

## Script Breakdown

1. **Repository and Branch Definition**:  
   The script starts by defining the URLs of the two repositories and their corresponding branches. You can modify the following variables:
   - `$repo1Url`: URL for the first repository (DemoIccMAX).
   - `$repo2Url`: URL for the second repository (PatchIccMAX).
   - `$repo1Branch`: Branch name from the first repository (e.g., `PCS_Refactor`).
   - `$repo2Branch`: Branch name from the second repository (e.g., `development`).

2. **Temporary Directory Creation**:  
   A temporary directory is created to store the cloned repositories. The script uses PowerShell's `[System.IO.Path]::GetTempPath()` and `[System.IO.Path]::GetRandomFileName()` to ensure unique directory names.

3. **Function to Clone and Checkout Branches**:  
   The `Clone-RepoAndCheckoutBranch` function is responsible for:
   - Cloning the specified repository using the `git clone` command.
   - Verifying that the specified branch exists in the repository.
   - Checking out the specified branch.

4. **Cloning and Checking Out Branches**:  
   The function is called twice to clone both repositories (`DemoIccMAX` and `PatchIccMAX`) and check out their respective branches.

5. **Performing the Diff**:  
   The script uses `git diff --no-index` to compare the two directories (excluding `.git` directories). The results are printed in two parts:
   - **Diff Stats**: Summarizes the differences, showing changes by file.
   - **Diff Summary**: Provides more detailed output about the changes.

6. **Cleanup (Optional)**:  
   After the comparison is done, the temporary directories can be cleaned up. The cleanup is optional, and you can uncomment the lines to remove the temporary directories if desired.

## Usage Instructions

1. **Install Git**:  
   Make sure Git is installed and available in your system's PATH.

2. **Run the Script**:  
   Modify the repository URLs and branch names as needed, and then run the script in PowerShell. Ensure you have sufficient privileges to clone the repositories and create directories.

3. **Optional Cleanup**:  
   To automatically delete the temporary directories after the comparison, uncomment the cleanup lines at the end of the script.

## Important Notes

- The script assumes both repositories are publicly accessible. If authentication is required, ensure you have the proper access tokens or credentials.
- The `git diff --no-index` command compares two directories that are not in the same Git repository.
- Be mindful of disk space, as cloning large repositories can consume significant space in the temporary directory.
