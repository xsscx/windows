# Export to SDK
$exportDirSDK = "F:\tmp\sdk"  # Define the directory where the SDK will be exported
$vcpkgCommandSDK = "$vcpkgExe export --output=$exportDirSDK --triplet=x64-windows --raw"
Write-Host "Exporting packages as SDK..."
Invoke-Expression $vcpkgCommandSDK

# Export to NuGet package
$exportDirNuGet = "F:\tmp\nuget"  # Define the directory where the NuGet package will be exported
$vcpkgCommandNuGet = "$vcpkgExe export --output=$exportDirNuGet --nuget --triplet=x64-windows"
Write-Host "Exporting packages as NuGet package..."
Invoke-Expression $vcpkgCommandNuGet

# Export to ZIP file
$exportDirZip = "F:\tmp\zip"  # Define the directory where the ZIP will be exported
$vcpkgCommandZip = "$vcpkgExe export --output=$exportDirZip --zip --triplet=x64-windows"
Write-Host "Exporting packages as ZIP file..."
Invoke-Expression $vcpkgCommandZip

Write-Host "All exports completed successfully."
