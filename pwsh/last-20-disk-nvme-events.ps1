Get-WinEvent -LogName System | Where-Object { $_.ProviderName -eq "disk" -or $_.ProviderName -like "*nvme*" } | Select-Object TimeCreated, Id, LevelDisplayName, Message -Last 20
