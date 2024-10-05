Get-ChildItem -Path "." -Recurse -Filter *.exe | ForEach-Object { $_.FullName }
