Get-WinEvent -LogName System | Where-Object { $_.Id -in 17, 18, 19, 20, 56, 1020, 1060 } | Select-Object TimeCreated, Id, LevelDisplayName, Message -Last 20
