Get-WinEvent -LogName System | Where-Object { $_.Id -in 41, 6008, 9, 11, 12, 13, 14, 15, 129 } | Select-Object TimeCreated, Id, LevelDisplayName, Message -Last 20
