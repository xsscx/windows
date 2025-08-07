# Corrected Dump File Search section
Write-Host "Searching for .dmp files in common crash dump locations..."

# Common dump file locations
$dumpFileLocations = @(
    "$env:LOCALAPPDATA\CrashDumps\",
    "$env:TEMP\",
    "C:\Windows\Temp\"
)

# Search for .dmp files
foreach ($location in $dumpFileLocations) {
    if (Test-Path $location) {
        $dmpFiles = Get-ChildItem -Path $location -Filter "*.dmp" -Recurse
        if ($dmpFiles) {
            Write-Host "Found .dmp files in ${location}:" -ForegroundColor Yellow
            $dmpFiles | Format-Table FullName, LastWriteTime -AutoSize
        } else {
            Write-Host "No .dmp files found in ${location}." -ForegroundColor Green
        }
    } else {
        Write-Host "Path ${location} does not exist." -ForegroundColor Red
    }
}
