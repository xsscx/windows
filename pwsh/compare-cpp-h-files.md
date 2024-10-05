
# PowerShell Script to Compare Two Git Repositories

## Overview

This PowerShell script automates the process of comparing two Git repositories by cloning them into a temporary directory, checking out specific branches, and performing a directory-level diff. It specifically filters for `.h` and `.cpp` files and generates patch files for any differences found between the two repositories.

## Features

- Clones two Git repositories into a temporary directory.
- Checks out specified branches for both repositories.
- Performs a directory-level diff, excluding `.git` directories.
- Filters the diff output to show only `.h` and `.cpp` files.
- Generates patch files for any differences found between the filtered files.
- Outputs a summary of the differences and saves patch files in a designated directory.

## Requirements

- PowerShell 5.1 or higher
- Git must be installed and available in the system's PATH
- Access to the internet to clone the repositories
- Write permissions to create a temporary directory and output files

## Usage

1. Modify the repository URLs and branch names in the script:
   ```powershell
   $repo1Url = "https://github.com/xsscx/DemoIccMAX.git"
   $repo2Url = "https://github.com/xsscx/PatchIccMAX.git"
   $repo1Branch = "main"
   $repo2Branch = "development"
   ```

2. Run the script in PowerShell:
   ```powershell
   .\compare-cpp-h-files.ps1
   ```

3. The script will:
   - Clone both repositories into a temporary directory.
   - Perform a directory diff, excluding `.git` directories.
   - Filter the diff output for `.h` and `.cpp` files.
   - Generate patch files for the filtered differences.

4. Check the `PatchIccMAX\patch` directory for the generated patch files.

## Notes

- Ensure you have Git installed before running the script.
- The script creates a temporary directory for the process and can optionally clean it up at the end.
- The patch files are stored in the `PatchIccMAX\patch` directory, which is created if it does not already exist.

