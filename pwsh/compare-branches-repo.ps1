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
