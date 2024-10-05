# Define the repositories and branches to compare
$repo1Url = "https://github.com/xsscx/DemoIccMAX.git"
$repo2Url = "https://github.com/xsscx/PatchIccMAX.git"
$repo1Branch = "main"  # Since DemoIccMAX only has main
$repo2Branch = "development"  # PatchIccMAX has development

# Create a temporary directory for the build process
$tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
Write-Host "Creating temporary directory: $tempDir"
New-Item -ItemType Directory -Path $tempDir -Force

# Define subdirectories for each repository within the temporary directory
$tempDir1 = [System.IO.Path]::Combine($tempDir, "DemoIccMAX")
$tempDir2 = [System.IO.Path]::Combine($tempDir, "PatchIccMAX")

# Clone the first repository
Write-Host "Cloning repository 1 into: $tempDir1"
git clone $repo1Url $tempDir1
cd $tempDir1

# Checkout the appropriate branch for DemoIccMAX
Write-Host "Checking out branch: $repo1Branch in repository 1"
git checkout $repo1Branch

# Clone the second repository
Write-Host "Cloning repository 2 into: $tempDir2"
git clone $repo2Url $tempDir2
cd $tempDir2

# Checkout the appropriate branch for PatchIccMAX
Write-Host "Checking out branch: $repo2Branch in repository 2"
git checkout $repo2Branch

# Perform the diff by directly comparing the directories, excluding .git directories
Write-Host "Performing directory diff..."
$summaryOutput = git diff --summary --no-index "$tempDir1" "$tempDir2" | Where-Object { $_ -notmatch ".git/" }

if ($summaryOutput) {
    Write-Host "Summary diff generated successfully."
} else {
    Write-Host "No differences found between directories or diff command failed."
}

# Filter for .h and .cpp files
Write-Host "Filtering for .h and .cpp files..."
$filteredFiles = $summaryOutput | Where-Object { $_ -match "\.h$|\.cpp$" }

if ($filteredFiles) {
    Write-Host "Found the following .h and .cpp files:"
    $filteredFiles | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "No .h or .cpp files found in the diff."
}

# Create directory for patch files
$patchDir = "PatchIccMAX\patch"
Write-Host "Creating patch directory: $patchDir"
New-Item -ItemType Directory -Path $patchDir -Force

# Create individual patch files
foreach ($file in $filteredFiles) {
    # Extract the file path from the summary output line
    if ($file -match '^(.*)create mode \d{6} "(.*)"') {
        $filePath = $matches[2]
    } elseif ($file -match '^delete mode \d{6} "(.*)"') {
        $filePath = $matches[1]
    } elseif ($file -match '^rename "(.*)" => "(.*)"') {
        $filePath = $matches[2]
    } else {
        continue
    }

    Write-Host "Generating patch for file: $filePath"

    # Generate the diff for the specific file
    $diffOutput = git diff --no-index -- "$tempDir1\$filePath" "$tempDir2\$filePath"
    
    if ($diffOutput) {
        # Determine the output file name for the patch
        $outputFileName = [System.IO.Path]::GetFileNameWithoutExtension($filePath) + ".patch"
        $outputFilePath = [System.IO.Path]::Combine($patchDir, $outputFileName)

        Write-Host "Writing patch to: $outputFilePath"

        # Write the diff to the patch file
        $diffOutput | Out-File -FilePath $outputFilePath -Encoding utf8
    } else {
        Write-Host "No diff output for file: $filePath"
    }
}

# Output the results to the console
Write-Output "`n--- Diff Summary ---`n"
Write-Output $summaryOutput | Out-Host

# Optional: Clean up the temporary directories
# Remove-Item -Recurse -Force $tempDir1
# Remove-Item -Recurse -Force $tempDir2
