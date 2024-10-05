Get-WinEvent -LogName System | Where-Object { $_.ProviderName -eq "Microsoft-Windows-WHEA-Logger" } | Select-Object TimeCreated, Id, LevelDisplayName, Message -Last 20
