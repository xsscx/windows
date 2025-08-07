# Define the root directory for the project
$rootDir = "C:\gits-repo-aug15\tmp\repo-dev-export"  # Replace with the actual path to your project

# Get all .vcxproj files in the root directory and subdirectories
$vcxprojFiles = Get-ChildItem -Path $rootDir -Recurse -Filter "*.vcxproj"

foreach ($file in $vcxprojFiles) {
    # Load the XML content of the .vcxproj file
    [xml]$xml = Get-Content -Path $file.FullName

    # Check if the <EnableASAN> element exists; if not, create it
    $propertyGroup = $xml.Project.PropertyGroup | Where-Object { $_.EnableASAN }
    
    if (-not $propertyGroup) {
        # Add <EnableASAN>false</EnableASAN> under the first PropertyGroup if not found
        $newElement = $xml.CreateElement("EnableASAN")
        $newElement.InnerText = "false"
        $xml.Project.PropertyGroup[0].AppendChild($newElement) | Out-Null
    } else {
        # Set the value of <EnableASAN> to false
        foreach ($asanElement in $propertyGroup.EnableASAN) {
            $asanElement.InnerText = "false"
        }
    }

    # Save the modified .vcxproj file
    $xml.Save($file.FullName)
    
    Write-Output "Updated: $($file.FullName)"
}

Write-Output "All .vcxproj files have been updated."
