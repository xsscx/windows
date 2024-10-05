# Define the directory containing the .icc files
$iccDirectory = "C:\gits-repo\PatchIccMAX\Testing\Display"  # Update this path to your directory
$outputDirectory = "C:\gits-repo\PatchIccMAX\icc-dump\output"  # Update this path to your desired output directory

# Ensure the output directory exists
if (-Not (Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory
}

# Define the path to iccDumpProfile.exe
$iccDumpProfileExe = "C:\Users\h0233\package\iccDumpProfile.exe"  # Update this path to your executable

# Get all .icc files in the specified directory
$iccFiles = Get-ChildItem -Path $iccDirectory -Filter *.icc

# Iterate through each .icc file
foreach ($iccFile in $iccFiles) {
    # Define the output file path
    $outputFile = Join-Path -Path $outputDirectory -ChildPath ($iccFile.BaseName + ".txt")

    # Run iccDumpProfile.exe on the current .icc file and capture the output
    & $iccDumpProfileExe $iccFile.FullName > $outputFile

    # Check if the command succeeded
    if ($LASTEXITCODE -eq 0) {
        Write-Output "Successfully dumped profile: $($iccFile.FullName) to $outputFile"
    } else {
        Write-Output "Failed to dump profile: $($iccFile.FullName)"
    }
}
