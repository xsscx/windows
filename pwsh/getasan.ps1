Param(
    [string]$version,
    [string]$branch_position,
    [string]$channel,
    [ValidateSet("linux", "mac", "win64", "cros")][string]$os,
    [string]$download_directory = ".",
    [switch]$save_log,
    [switch]$quiet
)

class ChromeRelease {
    [string]$os
    [string]$branch_position
    [string]$version
    [string]$channel
    [string]$true_branch

    ChromeRelease([string]$os, [string]$branch_position, [string]$version, [string]$channel, [string]$true_branch) {
        $this.os = $os
        $this.branch_position = $branch_position
        $this.version = $version
        $this.channel = $channel
        $this.true_branch = $true_branch
    }
}

function Get-CurrentOs {
    switch ($PSVersionTable.Platform) {
        "Win32NT" { return "win64" }
        "Unix"    { return "linux" }
        "MacOSX"  { return "mac" }
    }
}

function Fail {
    param ($msg)
    Write-Error $msg
    exit 1
}

function Fetch-Json {
    param ($uri)
    Write-Debug "Fetching JSON release metadata from ${uri}"
    try {
        $response = Invoke-RestMethod -Uri $uri -UseBasicParsing
        return $response
    } catch {
        Fail "Failed to fetch or parse release metadata from ${uri}"
    }
}

function Get-ReleaseMetadataByChannel {
    param ($release_info)
    $uri = "https://chromiumdash.appspot.com/fetch_releases?channel=$($release_info.channel)&platform=$($release_info.os)"
    $json_response = Fetch-Json -uri $uri
    if ($json_response.Count -gt 0) {
        $release_info.branch_position = $json_response[0].chromium_main_branch_position
        $release_info.true_branch = $json_response[0].branch
        $release_info.version = $json_response[0].version
    } else {
        Fail "No valid data returned from the ChromiumDash API."
    }
}

function Get-ReleaseMetadata {
    param ($release_info)
    if (-not $release_info.os) {
        $release_info.os = Get-CurrentOs
    }
    if (-not $release_info.branch_position) {
        if ($release_info.version) {
            Get-ReleaseMetadataByVersion -release_info $release_info
        } else {
            if (-not $release_info.channel) {
                $release_info.channel = if ($release_info.os -eq 'linux') { 'dev' } else { 'canary' }
            }
            Get-ReleaseMetadataByChannel -release_info $release_info
        }
    }
}

function Download-AsanChrome {
    param ($release_info, $download_dir, $quiet, $retries = 100)

    $os_to_path = @{
        "win64"      = "win32-release_x64/asan-win32-release_x64"
        "linux"      = "linux-release/asan-linux-release"
        "linux_debug" = "linux-debug/asan-linux-debug"
        "mac"        = "mac-release/asan-mac-release"
        "mac_debug"  = "mac-release/asan-mac-debug"
        "cros"       = "linux-release-chromeos/asan-linux-release"
    }

    if ($retries -lt 1) {
        Fail "Exceeded retry limit, aborting."
    }

    if (-not $release_info.branch_position) {
        Fail "Branch position is not available, aborting download."
    }

    $path = [uri]::EscapeDataString($os_to_path[$release_info.os])
    $asan_build_uri = "https://www.googleapis.com/download/storage/v1/b/chromium-browser-asan/o/$path-$($release_info.branch_position).zip?alt=media"
    $outfile_name = if ($release_info.version) { "chromium-$($release_info.version)-$($release_info.os)-asan.zip" } else { "chromium-$($release_info.branch_position)-$($release_info.os)-asan.zip" }
    $outfile_path = Join-Path -Path $download_dir -ChildPath $outfile_name

    try {
        Write-Debug "Fetching ASAN build from ${asan_build_uri}"
        Invoke-WebRequest -Uri $asan_build_uri -OutFile $outfile_path -ErrorAction Stop
        Write-Host "Download completed: $outfile_path"
        Expand-Archive -Path $outfile_path -DestinationPath $download_dir -Force
        Write-Host "Extraction completed successfully."
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404 -and $retries -gt 0) {
            if ([int]::TryParse($release_info.branch_position, [ref]$null)) {
                $new_branch_position = ([int]$release_info.branch_position - 1).ToString()
                Write-Warning "No ASAN build for $($release_info.os) at branch position $($release_info.branch_position), retrying at position $new_branch_position..."
                $release_info.branch_position = $new_branch_position
                if (Test-Path $outfile_path) {
                    Remove-Item -Path $outfile_path
                }
                Download-AsanChrome -release_info $release_info -download_dir $download_dir -quiet $quiet -retries ($retries - 1)
            } else {
                Fail "Branch position $($release_info.branch_position) is not a valid number."
            }
        } else {
            Fail "Failed fetching build from ${asan_build_uri}: $($_.Exception.Message)"
        }
    }
}

function Main {
    param ($release_info, $download_dir, $quiet)
    Get-ReleaseMetadata -release_info $release_info
    Download-AsanChrome -release_info $release_info -download_dir $download_dir -quiet $quiet
}

$loglevel = if ($quiet) { "Warning" } else { "Information" }

if ($save_log) {
    $logfile_name = "$((Get-Item $MyInvocation.MyCommand.Path).BaseName)-$(Get-Date -Format yyyyMMdd).log"
    Start-Transcript -Path $logfile_name
}

$release_info = [ChromeRelease]::new($os, $branch_position, $version, $channel, $null)
Main -release_info $release_info -download_dir $download_directory -quiet $quiet

if ($save_log) {
    Stop-Transcript
}
