###########################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
#
## Date: 24-FEB-2025 1325 EST by David Hoyt
## Intent: Poll the Device and Report for Troubleshooting
#
## TODO: Refactor
##
# Open a Developer Powershell Terminal
# cd to $Project_Root/
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/windows/refs/heads/main/pwsh/iccdevenv.ps1").Content
#
#
#
###########################################################

Write-Host "== Starting Windows Development Troubleshooter ==" -ForegroundColor Green
Write-Host "== Run from Project_Root ==" -ForegroundColor Cyan
Write-Host "== cd iccDEV ==" -ForegroundColor Cyan
Write-Host "Copyright (c) 2024-2025 David H Hoyt LLC. All rights reserved." -ForegroundColor White

systeminfo
Write-Host "`n== Checking for vswhere.exe... ==" -ForegroundColor Green
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"

# 1. List all local branches
git branch

# 5. Show the current repository status
git status -s

# 6. List all configured remotes and their URLs
git remote -v

          vcpkg integrate install
          vcpkg install
          cmake --preset vs2022-x64 -B . -S Build/Cmake  > cmake.log 2>&1
          cmake --build . -- /m /maxcpucount  >> cmake.log 2>&1
          $toolDirs = Get-ChildItem -Recurse -File -Include *.exe -Path .\Tools\ | ForEach-Object { Split-Path -Parent $_.FullName } | Sort-Object -Unique
          $env:PATH = ($toolDirs -join ';') + ';' + $env:PATH
          $env:PATH -split ';'
          cd Testing
          .\CreateAllProfiles.bat
          .\RunTests.bat
          cd CalcTest\
          .\checkInvalidProfiles.bat
          .\runtests.bat
          cd ..\Display
          .\RunProtoTests.bat
          cd ..\HDR
          .\mkprofiles.bat
          cd ..\mcs\
          .\updateprev.bat
          .\updateprevWithBkgd.bat
          cd ..\Overprint
          .\RunTests.bat
          cd ..
          cd hybrid
          .\BuildAndTest.bat
          cd ..
          cd ..


LogBanner -Title "End of Troubleshooting Report"
Log "Troubleshooting completed successfully."

Write-Host "============================= Exiting Windows Development Troubleshooter =============================" -ForegroundColor White
