# Set the path to vcpkg
$vcpkgDir = "C:\tmp\vcpkg-master\vcpkg-master\"
$vcpkgExe = "$vcpkgDir\vcpkg.exe"

# Reinstall the packages with the required features to ensure they're marked for export
$packagesToInstall = @(
    "libxml2[iconv,lzma,zlib]:x64-windows",
    "tiff[jpeg,lzma,zip]:x64-windows",
    "pcre2[jit,platform-default-features]:x64-windows",
    "wxwidgets[debug-support,sound]:x64-windows"
)

# Reinstall the packages
foreach ($package in $packagesToInstall) {
    $vcpkgInstallCommand = "$vcpkgExe install $package --recurse --editable"
    Write-Host "Reinstalling package: $package"
    Invoke-Expression $vcpkgInstallCommand
}
