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
