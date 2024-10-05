# Define the repositories and branches to compare
$repo1Url = "https://github.com/xsscx/DemoIccMAX.git"
$repo2Url = "https://github.com/xsscx/PatchIccMAX.git"
$repo1Branch = "PCS_Refactor"  # Since DemoIccMAX only has main
$repo2Branch = "development"  # PatchIccMAX has development

# Create a temporary directory for the build process
$tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $tempDir -Force

# Define subdirectories for each repository within the temporary directory
$tempDir1 = [System.IO.Path]::Combine($tempDir, "DemoIccMAX")
$tempDir2 = [System.IO.Path]::Combine($tempDir, "PatchIccMAX")

# Clone the first repository
git clone $repo1Url $tempDir1
cd $tempDir1

# Checkout the appropriate branch for DemoIccMAX
git checkout $repo1Branch

# Clone the second repository
git clone $repo2Url $tempDir2
cd $tempDir2

# Checkout the appropriate branch for PatchIccMAX
git checkout $repo2Branch

# Perform the diff by directly comparing the directories, excluding .git directories
$diffOutput = git diff --stat --no-index "$tempDir1" "$tempDir2" | Where-Object { $_ -notmatch ".git/" }
$summaryOutput = git diff --summary --no-index "$tempDir1" "$tempDir2" | Where-Object { $_ -notmatch ".git/" }

# Output the results to the console
Write-Output "`n--- Diff Stats ---`n"
Write-Output $diffOutput | Out-Host
Write-Output "`n--- Diff Summary ---`n"
Write-Output $summaryOutput | Out-Host

# Optional: Clean up the temporary directories
# Remove-Item -Recurse -Force $tempDir1
# Remove-Item -Recurse -Force $tempDir2
