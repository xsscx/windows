function Get-SymlinkTargetDirectory {           
    [cmdletbinding()]
    param(
        [string]$SymlinkDir
    )
    $basePath = Split-Path $SymlinkDir
    $folder = Split-Path -leaf $SymlinkDir
    $dir = cmd /c dir /a:l $basePath | Select-String $folder
    $dir = $dir -join ' '
    $regx = $folder + '\ *\[(.*?)\]'
    $Matches = $null
    $found = $dir -match $regx
    if ($found) {
        if ($Matches[1]) {
            Return $Matches[1]
        }
    }
    Return '' 
}
