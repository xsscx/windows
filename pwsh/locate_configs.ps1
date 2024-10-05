# Run from contrib/Build/VS2022E/ or adjust the Relative Path
Get-ChildItem -Path (Resolve-Path "../../../../").Path -Recurse -File | Where-Object { $_.Extension -match '(\.vcxproj|\.sln|\.vcproj|\.filters|\.props)' } | ForEach-Object { Write-Host "Found: $($_.FullName)" }
