$Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NoProfile -ExecutionPolicy Bypass -Command "iex (iwr -Uri ''https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_revert_master_branch.ps1'').Content"'; 

$Trigger = New-ScheduledTaskTrigger -AtLogOn -User 'User';

$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable;

Register-ScheduledTask -TaskName 'RunOnceDemoScript' -Action $Action -Trigger $Trigger -Settings $Settings -User 'User'
