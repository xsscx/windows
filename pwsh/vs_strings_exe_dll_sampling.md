# PowerShell Script Examples for Extracting Strings from Executables and DLLs

This repository contains several PowerShell script examples that extract specific string patterns from `.exe`, `.dll`, `.pdb`, and `.lib` files in a Visual Studio installation directory. The scripts log these extracted strings into files and include optional metadata such as file size, timestamps, and sequential numbering.

## Prerequisites

- PowerShell
- `strings` command-line utility (available on Windows, typically part of Sysinternals Suite)
- Visual Studio installation in the `C:\Program Files\Microsoft Visual Studio\2022\Enterprise` path

Each script searches for strings matching the pattern `^(Dbg|Dev|Internal|Undocumented|Assert|Get|Set|Create|Delete|Open)[A-Za-z0-9_]+$` inside executable and library files. The results are then written to log files.

## Examples Overview

### 1. Sequential Numbering with Action Description

**Script Block:**  
Extracts strings from `.exe`, `.dll`, `.pdb`, and `.lib` files, appending them to a log file with a fixed sequential name (`vs_strings_exe_dll_log_1.txt`). Temporary sorting is done in a separate file, which is copied to the original log.

- **Log File:** `vs_strings_exe_dll_log_1.txt`
- **Temporary Sorted File:** `vs_strings_exe_dll_sorted_1.txt`

### 2. Including File Size and Timestamp

**Script Block:**  
Similar to example 1, but includes the file size and the current timestamp for each extracted string. 

- **Log File:** `vs_strings_exe_dll_log_2.txt`
- **Temporary Sorted File:** `vs_strings_exe_dll_sorted_2.txt`

### 3. Including a Timestamped Header

**Script Block:**  
This example adds a header at the beginning of the log, indicating when the script run started. The log filename is based on the current date and time, ensuring each log file is unique.

- **Log File:** `vs_strings_log_run_YYYYMMDD_HHMMSS.txt`
- **Temporary Sorted File:** `vs_strings_sorted_run_YYYYMMDD_HHMMSS.txt`

### 4. Sequential Numbering with Timestamped Log

**Script Block:**  
This script appends the current timestamp as a header in the log file (`vs_strings_log_run_503.txt`). Sorting is done in a temporary file, which is copied to the log file after sorting.

- **Log File:** `vs_strings_log_run_503.txt`
- **Temporary Sorted File:** `vs_strings_sorted_run_503.txt`

### 5. Unique Filenames Based on Date

**Script Block:**  
Each run of this script generates a uniquely named log file based on the current date and time (`YYYY-MM-DD_HH-mm-ss`), ensuring logs from different runs do not overwrite each other.

- **Log File:** `vs_strings_log_YYYY-MM-DD_HH-mm-ss.txt`
- **Temporary Sorted File:** `vs_strings_sorted_YYYY-MM-DD_HH-mm-ss.txt`

### 6. Backup with Sequential Numbering and Timestamp

**Script Block:**  
Before starting the string extraction, this script creates a backup of the existing log file. The backup file is named based on the current date and time.

- **Log File:** `vs_strings_log_703.txt`
- **Backup File:** `vs_strings_backup_YYYY-MM-DD_HH-mm-ss.txt`
- **Temporary Sorted File:** `vs_strings_sorted_703.txt`

### 7. Sequential Log with File Size and Timestamp

**Script Block:**  
Includes both file size and the current timestamp for each string in the log file (`vs_strings_exe_dll_log_803.txt`). Sorting is done in a temporary file, which is copied into the log file.

- **Log File:** `vs_strings_exe_dll_log_803.txt`
- **Temporary Sorted File:** `vs_strings_exe_dll_sorted_803.txt`

### 8. Sequential Log with Extra Extensions

**Script Block:**  
This script searches `.exe`, `.dll`, `.pdb`, and `.lib` files, logs matching strings, and appends them to a log file with a fixed name (`vs_strings_exe_dll_pdb_lib_log_903.txt`). Temporary sorting is handled in a separate file.

- **Log File:** `vs_strings_exe_dll_pdb_lib_log_903.txt`
- **Temporary Sorted File:** `vs_strings_exe_dll_pdb_lib_sorted_903.txt`

## General Workflow

1. **Search Files:** Each script recursively searches through `C:\Program Files\Microsoft Visual Studio\2022\Enterprise` for specific file types (`.exe`, `.dll`, etc.).
   
2. **Extract Strings:** The `strings` utility is used to extract patterns that match certain prefixes (e.g., `Dbg`, `Dev`, `Assert`, `Create`).
   
3. **Log Data:** The matching lines, along with optional metadata (size, timestamps), are written to a log file. Sorting is done in a temporary file, and then copied to the original log.

4. **File Preservation:** Temporary files are preserved for future reference. No files are deleted after the script runs.

## File Handling

- The `Copy-Item` command is used to ensure that both the temporary sorted files and the final log files are preserved after each run.
- The `-Force` parameter is used to allow overwriting the log files if they already exist.

## Notes

- Ensure that the `P:\temp` directory exists and has sufficient storage space for logs.
- You can customize the directory paths and file extensions based on your specific needs.
- If you need to search additional extensions, modify the `Get-ChildItem` (`gci`) command in the scripts.
