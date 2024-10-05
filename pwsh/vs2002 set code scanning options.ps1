Get-ChildItem -Recurse -Filter *.vcxproj | ForEach-Object {
    (Get-Content $_.FullName) -replace '<RunCodeAnalysis>true</RunCodeAnalysis>', '<RunCodeAnalysis>false</RunCodeAnalysis>' | Set-Content $_.FullName
}
