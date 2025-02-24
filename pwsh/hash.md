# Hash List

### Command

```
Get-ChildItem -Path . -Filter *.ps1 | ForEach-Object {$ps1 = $_.Name & "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe" verify /pa /v $_.FullName | Select-String -Pattern 'Hash of file \(sha256\):' | ForEach-Object { "$($ps1): $($_.Line.Split(':')[-1].Trim())" }}
```

### Result
```
asan-change-propeties.ps1: 673403BAEBA5F9BEBE78A2D20EFD3ACDBAF8503D62A0A844C6A3A84E5C398091
build_demoiccmax_once_at_login.ps1: 767CB43130B87AE7FD0200F1B5B4B8F3DC9D06856C92513A414528C3FD423FA6
change_power_configs_fuzzing.ps1: D64A3C7C6228703A24CE069C5A04D32D4997CF2AD50A61EA7744B0CB4F9F460A
compare-branches-repo.ps1: 90802C3F61F52973EA91A513413E0F028B63DEBE84C74E9517C684A997AC1A87
compare-cpp-h-files.ps1: 9B447B7D68A50BBA6A9F7BD5C168CA7D59C67555317DE3A715FDE6838982F52F
copy-consolehost-history.ps1: 4A80DDABC0EF7524B4A937CAF903F3DF64F22D216088CC1634F91B78B77F295F
devenv-asan-enable-vcxproj-subst-replace.ps1: 53DB82D97E70CDCE7D6B522C443975B2D21ABE06956C0F0DE612703343664DFC
dmp-search.ps1: 6E1C0A5A9C507FA1D9E29570B9260D8CA9356E09F53A7990D51C4D3C16277B5C
dump-consolehistory.ps1: F23DBD217572CF3DC8F13B89A598F3E2135DCCC180068FC9D4FD6964C1D235B6
dump-icc-color-profiles.ps1: F49C7B669A9B7A27F79094225DCA238601C038AD89DDB6142AB93FDFD4157F76
enable_long_paths.ps1: B61AE439FCAD85168257B2A7C524BC91BB496F2DFF553EBAF02FB0C1EE84915A
find-compiled-exe-dll-lib.ps1: 5B432081D6B92A872B5B7AC2E98DDC53F180BC4E11462ADD37DC982508B9332A
find-exe-files.ps1: B7967F2488A68CA398FA9ADC6CBA9F1B9F94281F73F96F934C7B3AA283CDB60B
find-executables-libraries-project-root.ps1: 1947278FC91EBAC784C1D921700132334979997A621F427484658245080776D8
find-vs2022-config-files.ps1: 53E48EE4798832696CFA680021D796238F71D6EF159DA2048A26B6A0A70986A6
get-pci-slot-details.ps1: A547206D0947B6F2E44C14E98E349387C97DDDD88A266640166D78ABD455F089
getasan.ps1: D2AE88011EA9CCEFAE5A4B0CB6E0DC74545652CB0EEB32757E5891ABF89E7144
git-diff-output-console-indivual-repo-file-diff.ps1: CF9870BE931F04B53B9DAF982914098BB1ABB1424E865843DD2EBCA7B7BE3B2D
git-diff-repos-create-patches.ps1: 037CBB08353D2D60A61213138D61514C7FE0FB6AC0B66D0A3E567E7BD6DBF82A
git-install.ps1: 0C78BFB96DA1B884A5FBFB0BCEFD9E9790E086A6ABDFD43FD916E894E00FCF3F
git-repos-compare-stats-summary-file-listing.ps1: 088E4F092365654139647498F5A56310EBF8AAF9609B9CD8345C644EB56345C1
increase_file_handles.ps1: AFF59A4921973F55C7F8C282DD39E039D83A6D65B0C29E13C6342DD101398334
install-wget.ps1: 179CE0A23EA5D1912A623AEDE95D35F97109108318A6B1B29449BA29225A8964
install_jq.ps1: 9E9B63A06D9285F49F355F84B3120C619D17851D9D5000B23A84DE0117DAB571
install_min_dep_icc.ps1: AC04DF97FAFFB3AEF8F2E3F901D14F1A4E91C55669B658ED589DA82122642F01
install_tools.ps1: C1973B3C3E73C5D4CCC66B4B4F0DC26364E50C260AF27955D99BFE05EDA5FDFA
large-directories.ps1: C4D4A128F588DB945F1280A8170D5762A73E42BAF029481CD3DF28BA0BBDDEE8
last-20-disk-nvme-events.ps1: 03C2068C61666EB8FDD4E90CCA74F51C499466D752AB6CAEF1E188600F0975E0
last-20-hardware-related-crash-events.ps1: 20B723DE4AA2DF4955DB133599324E194611B3660EAEB7E29C55580C882392D3
last-20-pci-nvme-events.ps1: 155BFE8EB3F53CBAA80B3B8F8AB671B332122053E2530B1D2CEFEAA7EA81A039
last-20-whea-log.ps1: 3DF6F3E8F127A409D12A7A46424492EE1EC3F0D572F639875C7FCE1C436058CA
list-drives-guid-summary.ps1: 1DA3CED660088863E0BA8D7FCD138C79B55A2651E0DE9E5959713C2192864C06
list_junctions.ps1: 43938CFD75C2F88D0B2F346EF7DC7C943037AF60F332198F7C04F8DED0BA231B
locate_configs.ps1: 97BC3276F5643A733388516FBD2827CEC8CD0C610EF29730F1FA3912A469164F
mailboxreports-example-001.ps1: A429D2B0ADBED78FE8C1E1A76E0735FBE490543B5FD0722022F69E0BE75B9B3D
mediumriskactivities-example-001.ps1: 81FC8EEE604B1D936DE9331A49C66EE143CA7AB57B9DA2303D9795474463100C
Microsoft.PowerShell_profile.ps1: EB42F313DEC789BF812456ABF6E1948B136D3B7CAA55D1EECC5F45BE9951968F
patchmax-clone-repo-development-branch-build.ps1: 85D3672BFA773272759C29E129950EDDBF73B68F1AD5838B08993B04DCE3426E
pci-get-details.ps1: 6602C038615ACBF608CD0B10FB2AB72B87811C0214298AB4C17A913CD00E6BBD
project-export-zip-nuget-sample-001.ps1: 61A1BB94F93248E0B6A9C9ADE25594D3A6C9BC8FBF463B0954D88F645FA9E7B4
remove_clang.ps1: BD1963BFA2990194183E02B54EA49CF29934B05B1EFD20A2B8EA479E841E6EA5
sample-package-source.ps1: A9FD531B5C063B73DBA6830795A7518862E7D7760398888C3BE162E67C5B7ABD
set_app_crash_location.ps1: 4888C01BF9DC44E1D5CD65D48A745F5ACC49FB1E636D3AFDBF4424797762B0ED
set_developer_powershell_default_terminal.ps1: 5302779B8BA3EB6406CC18243E941CB92CD218CB5C1E4FB2B9A35A56F72BAF2A
set_kernel_crash_location.ps1: 46AE3940C8F7118C04D395F5BCE4D94F73597245A9292D77E73B4449C1395402
show-workload-info-example-001.ps1: D0A5E698FE87F8713B90781D097C7969F3BCE8BD4008C3999DA3673CC8867243
Sign-AllScripts.ps1: 68C19266701D20EDADFE1FE42B776EA3FB198AFE71767DA6B8C7E98D1451505F
sign-exe-files-sample.001.ps1: 4B3B4CC382C895E7CA6ABF5E029F6908EAD9937B241A78DC3E5758D453EF3CA7
sizeof-tenant-audit-logs-example-001.ps1: 49E5C7A59249145F8694A4F2FAD26C532DF520C9A55166604C3A59F9F375CB37
sql_server_check.ps1: 111729135212426F6772D15E535F80FE98788386161FC5AC02017019311C3B87
sysinfo.ps1: 68E05B44B21BA9AC2CE07CCB811A308C04B7EFFD0AE9295588C48A9B2D7BD8CB
unifiedauditlog-ytd-harvest-sample-001.ps1: D0A5E698FE87F8713B90781D097C7969F3BCE8BD4008C3999DA3673CC8867243
usb-get-details.ps1: F0C62AF5FC60323CE167FC7D4634C21D68000C3AF0AA1E00C54094C8826D79EB
vcpkg-copy-libs-demoiccmax-deps-001.ps1: 323DE674AB0A05B9FF0DA602D57B752A935F4D396C623854827AA20CB50A8D08
vcpkg-export-sdk-static-deps.ps1: 03EDC2104909A068CFE674882B7A579C79A0115EE268743BFC705A7D4A94C5CC
vcpkg-install-demoiccmax-deps-001.ps1: 4969CD5F6DFA3E0967BE1B812CA07B3382FC154AED3F885DF71169424A79C91F
verify-signtool-checks-logfile.ps1: 9D83DA30214F5860A2CE57FEB7841C2B0693A985A940C280CD1D5AC90B684357
verify-signtool-checks.ps1: BF6642030E41DF612F09533C83B2D3A1F62E3DD585DE04E4D56E6EF61D9FF3F0
vs2002 set code scanning options.ps1: CD475FC95FC42D81B312094CEA298A7A9B56E05A744A8401BB25E7D8A804AB33
vs2022_build_from_patch.ps1: 2F8896597F3EA65DDA4779787116737473F986D555FC2E360D25D27C317ACB3B
vs2022_remove_clang_asan.ps1: E0B1CBDE6FF50DDC8A1510039770F0F979446BEF5D4CB07B29B5FBA113C01F35
vs_strings_exe_dll_sampling.ps1: F9799B1FFEDD53541B4B5809076455876A3653127D25502A94483B4113555D3E
```
