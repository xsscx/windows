# Set the target directory (C:\ drive) and the number of top directories to list
$targetDirectory = "C:\"
$topN = 100
$reportFilePath = "C:\LargeDirectoriesReport.txt"

# Function to calculate the size of a directory
function Get-DirectorySize {
    param (
        [string]$directoryPath
    )

    # Initialize the total size and file count
    $totalSize = 0
    $fileCount = 0

    # Get all files in the directory and its subdirectories
    try {
        Get-ChildItem -Path $directoryPath -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            $totalSize += $_.Length
            $fileCount++
        }
    } catch {
        Write-Host "Error accessing $directoryPath" -ForegroundColor Yellow
    }

    return [PSCustomObject]@{
        Path = $directoryPath
        Size = $totalSize
        FileCount = $fileCount
    }
}

# Get a list of top-level directories
$directories = Get-ChildItem -Path $targetDirectory -Directory -ErrorAction SilentlyContinue

# Calculate the size for each directory and sort by size
$directorySizes = $directories | ForEach-Object { Get-DirectorySize -directoryPath $_.FullName } | Sort-Object Size -Descending

# Select the top N largest directories
$topDirectories = $directorySizes | Select-Object -First $topN

# Convert the size to a human-readable format and generate the report
$reportContent = $topDirectories | ForEach-Object {
    [PSCustomObject]@{
        "Directory Path" = $_.Path
        "Size (Bytes)" = $_.Size
        "Size (GB)" = "{0:N2}" -f ($_.Size / 1GB)
        "File Count" = $_.FileCount
    }
}

# Output the report to a text file
$reportContent | Format-Table -AutoSize | Out-File -FilePath $reportFilePath

# Display the report to the console
Write-Host ("Report of the top {0} largest directories on {1}:" -f $topN, $targetDirectory)
$reportContent | Format-Table -AutoSize

Write-Host "`nThe report has been saved to $reportFilePath."
