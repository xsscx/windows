# PowerShell Script for Modifying Visual Studio Installation with vs_installer.exe

This PowerShell script uses `vs_installer.exe` to modify an existing Visual Studio installation. Specifically, it removes certain components (in this case, Clang-related components) from the specified Visual Studio installation path.

## Overview

- **Modifies a Visual Studio Installation**: Uses `vs_installer.exe` to remove specific components from an existing Visual Studio installation.
- **Removes Clang Components**: The script removes Clang-related components from the Visual Studio installation.

## Script Details

### PowerShell Command:

```powershell
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" modify `
  --installPath "C:\Program Files\Microsoft Visual Studio\2022\Enterprise" `
  --remove Microsoft.VisualStudio.Component.ClangCompiler `
  --remove Microsoft.VisualStudio.ComponentGroup.Native.Clang
