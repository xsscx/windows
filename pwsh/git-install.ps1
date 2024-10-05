# Install Git using winget
winget install --id Git.Git -e --source winget

# Define the path to the Git executable
$gitPath = "C:\Program Files\Git\cmd"

# Add Git to the PATH if it's not already there
if (-not ($env:Path -contains $gitPath)) {
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $gitPath, [System.EnvironmentVariableTarget]::Machine)
}

# Verify Git installation
git --version
