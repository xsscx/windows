import argparse
import datetime
import json
import logging
import os
import platform
import sys
from urllib.request import urlretrieve, urlopen
from urllib.parse import quote as urlquote
from urllib import error as urlliberror

class ChromeRelease:
    def __init__(self, os, branch_position, version, channel, true_branch) -> None:
        self.os = os
        self.branch_position = branch_position
        self.version = version
        self.channel = channel
        self.true_branch = true_branch

def get_current_os():
    return {
        'Windows': 'win64',
        'Linux': 'linux',
        'Darwin': 'mac',
    }[platform.system()]

def fail(msg):
    logging.fatal(msg)
    logging.shutdown()
    exit()

def fetch_json(url):
    logging.debug(f'Fetching JSON from {url}')
    try:
        with urlopen(url) as resp:
            if resp.status != 200:
                fail(f'Failed to fetch data from {url}')
            try:
                return json.loads(resp.read())
            except json.JSONDecodeError as e:
                fail(f'Failed to parse JSON response from {url}')
    except urlliberror.HTTPError as e:
        fail(f"Failed to fetch data: {e}")

def get_release_metadata_by_channel(release_info):
    uri = f'https://chromiumdash.appspot.com/fetch_releases?channel={release_info.channel}&platform={release_info.os}'
    json_response = fetch_json(uri)
    if isinstance(json_response, list) and len(json_response) > 0:
        release_info.branch_position = json_response[0].get('chromium_main_branch_position')
        release_info.true_branch = json_response[0].get('branch')
        release_info.version = json_response[0].get('version')
    else:
        fail("No valid data returned from the ChromiumDash API.")

def get_release_metadata(release_info):
    if not release_info.os:
        release_info.os = get_current_os()
    if release_info.branch_position:
        return
    elif release_info.version:
        get_release_metadata_by_version(release_info)
    else:
        if not release_info.channel:
            release_info.channel = 'canary' if release_info.os != 'linux' else 'dev'
        get_release_metadata_by_channel(release_info)

def download_asan_chrome(release_info, download_dir, quiet, retries=100):
    def ReportHook(blocknum, blocksize, totalsize):
        if quiet:
            return
        size = blocknum * blocksize
        if totalsize == -1:
            progress = f'Received {size} bytes'
        else:
            size = min(totalsize, size)
            percent = 100 * size / totalsize
            progress = f'Received {size} of {totalsize} bytes, {percent:.2f}%'
        sys.stdout.write('\r' + progress)
        sys.stdout.flush()

    os_to_path = {
        'win64': 'win32-release_x64/asan-win32-release_x64',
        'linux': 'linux-release/asan-linux-release',
        'linux_debug': 'linux-debug/asan-linux-debug',
        'mac': 'mac-release/asan-mac-release',
        'mac_debug': 'mac-release/asan-mac-debug',
        'cros': 'linux-release-chromeos/asan-linux-release',
    }

    if retries < 1:
        fail('Exceeded retry limit, aborting.')

    if not release_info.branch_position:
        fail('Branch position is not available, aborting download.')

    path = urlquote(os_to_path[release_info.os], safe='')
    asan_build_uri = (f'https://www.googleapis.com/download/storage/v1/b/'
                      f'chromium-browser-asan/o/{path}-'
                      f'{release_info.branch_position}.zip?alt=media')
    if release_info.version:
        outfile_name = (f'chromium-{release_info.version}'
                        f'-{release_info.os}-asan.zip')
    else:
        outfile_name = (f'chromium-{release_info.branch_position}-'
                        f'{release_info.os}-asan.zip')
    outfile_path = os.path.join(download_dir, outfile_name)
    try:
        logging.debug(f'Fetching ASAN build from {asan_build_uri}')
        outfile_path, _ = urlretrieve(asan_build_uri, outfile_path, ReportHook)
    except urlliberror.HTTPError as e:
        if e.code == 404 and retries > 0:
            if release_info.branch_position.isdigit():
                new_branch_position = str(int(release_info.branch_position) - 1)
                logging.warning(
                    f'No ASAN build for {release_info.os} at branch position '
                    f'{release_info.branch_position}, retrying at position '
                    f'{new_branch_position}...')
                release_info.branch_position = new_branch_position
                if os.path.exists(outfile_path):
                    os.unlink(outfile_path)
                download_asan_chrome(release_info, download_dir, quiet,
                                     retries - 1)
            else:
                fail(f'Branch position {release_info.branch_position} is not valid.')
        else:
            fail(f'Failed fetching build from {asan_build_uri}: {e}')

def main(release_info, download_dir, quiet):
    get_release_metadata(release_info)
    download_asan_chrome(release_info, download_dir, quiet)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--version', help='Chrome version, e.g. 105.0.5191.2.')
    group.add_argument('--branch_position',
                       help='Chrome branch base position, e.g. 1025959.')
    group.add_argument('--channel',
                       choices=['canary', 'dev', 'beta', 'stable'],
                       help='Chromium channel, e.g. canary.')
    parser.add_argument('--os',
                        choices=['linux', 'mac', 'win64', 'cros'],
                        help='Operating system type as defined by ChromiumDash.')
    parser.add_argument(
        '--download_directory',
        default='.',
        help='Path of directory where downloaded ASAN build will be saved.')
    parser.add_argument('--save_log',
                        help='Save activity log to disk.',
                        action='store_true',
                        default=False)
    parser.add_argument(
        '--quiet',
        help='Decrease log output and don\'t show download progress.',
        action='store_true',
        default=False)
    args = parser.parse_args()

    loglevel = logging.INFO
    if args.quiet:
        loglevel = logging.WARN
    if args.save_log:
        logfile_name = os.path.basename(__file__).strip(
            '.py') + '-' + datetime.datetime.now().strftime('%Y%m%d') + '.log'
        stdout_handler = logging.FileHandler(filename=logfile_name)
        stderr_handler = logging.StreamHandler(sys.stderr)
        logging.basicConfig(level=loglevel,
                            handlers=[stdout_handler, stderr_handler])
    else:
        logging.basicConfig(level=loglevel)

    release_info = ChromeRelease(args.os, args.branch_position, args.version,
                                 args.channel, None)
    main(release_info, args.download_directory, args.quiet)
