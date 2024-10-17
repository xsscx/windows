# Set the maximum number of file handles allowed per process
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'MaxMpxCt' -Value 65535 -PropertyType DWORD -Force
