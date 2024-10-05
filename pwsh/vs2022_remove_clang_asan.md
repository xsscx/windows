
# Removing Clang Compiler Components from Visual Studio

This script demonstrates how to modify an existing Visual Studio installation using the Visual Studio Installer command-line tool (`vs_installer.exe`). Specifically, it removes the `Clang Compiler` and related components from the Visual Studio installation at a specified path.

## Prerequisites

- Visual Studio 2022 is already installed on your machine.
- You have administrative privileges to modify the Visual Studio installation.
- The Visual Studio Installer is located at `C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe`.

## Command Overview

The command below uses the Visual Studio Installer to modify the installation, removing the following components:
- **Microsoft.VisualStudio.Component.ClangCompiler**: The Clang compiler for C/C++ development.
- **Microsoft.VisualStudio.ComponentGroup.Native.Clang**: The Native Clang component group, which includes the Clang compiler and related build tools.

### Command

```bash
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" modify --installPath "C:\Program Files\Microsoft Visual Studio\2022\Enterprise" --remove Microsoft.VisualStudio.Component.ClangCompiler --remove Microsoft.VisualStudio.ComponentGroup.Native.Clang
```

### Breakdown of the Command

1. **vs_installer.exe**: This is the executable for the Visual Studio Installer.
   
2. **modify**: The action to modify the existing installation (as opposed to installing new components or uninstalling the entire product).

3. **--installPath "C:\Program Files\Microsoft Visual Studio\2022\Enterprise"**: This specifies the path to the Visual Studio installation you want to modify. In this case, it's the 2022 Enterprise edition.

4. **--remove Microsoft.VisualStudio.Component.ClangCompiler**: This removes the `Clang Compiler` component from the current Visual Studio installation.

5. **--remove Microsoft.VisualStudio.ComponentGroup.Native.Clang**: This removes the `Native Clang` component group, which includes tools for building native applications using Clang.

### How to Run the Command

1. Open PowerShell **as an Administrator**.

2. Copy and paste the command into your PowerShell window.

3. Press **Enter** to execute the command.

4. The Visual Studio Installer will launch in the background and begin modifying your installation.

### Verifying the Changes

To verify that the components have been successfully removed:

1. Open Visual Studio.
2. Go to the **Tools** menu and select **Get Tools and Features**.
3. Under the **Workloads** tab, look for **Desktop Development with C++** (or any workload containing Clang support). The Clang-related components should no longer be installed.
   
Alternatively, you can re-run the Visual Studio Installer and check the individual components to see if the `Clang Compiler` and `Native Clang` are unchecked.

### Troubleshooting

- **Error: Access Denied**: Ensure you are running PowerShell as an Administrator.
- **Component Not Found**: If the command fails to remove a component, it may not be installed in the first place. You can run the installer manually to verify which components are installed.

### Notes

- You can modify this command to remove or add other components by referencing their respective component IDs. A full list of Visual Studio component IDs can be found on the [Microsoft documentation](https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-enterprise?view=vs-2022).
- For further assistance, you can consult the Visual Studio Installer command-line reference by running:

```bash
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" help
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
