Get-ChildItem -Path . -Recurse -Filter *.exe | ForEach-Object { Write-Output $_.FullName }
