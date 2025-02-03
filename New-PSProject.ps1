<#
.SYNOPSIS
    This script creates a folder structure for a PowerShell project.
.DESCRIPTION
    This script creates a folder structure for a PowerShell project. The folder
    structure includes the following folders:
    - Modules: Contains the PowerShell modules for the project.
    - Scripts/Public: Contains the public scripts for the project.
    - Scripts/Private: Contains the private scripts for the project.
    - Tests: Contains the test scripts for the project.
    - Resources/Images: Contains the images used in the project.
    - Resources/Data: Contains the data files used in the project.
    - Documentation/Pages: Contains the documentation pages for the project.
    It also creates some default files in the folders, such as module files, script
    files, test files, image files, data files, and documentation files.
.EXAMPLE
    Build-PSProjectStructure.ps1
    This command will prompt you for the name of the project and create the folder structure.
.NOTES
    File Name      : New-PSProject.ps1
    Author         : Michelle Broussard
    Last Modified  : 2 February 2025
#>
function New-PSProject {
    [CmdletBinding()]
    param()

    # Define the root folder
    $rootFolder = Read-Host "Enter the name of the project"

    # Define the folder structure
    $folders = @(
        "$rootFolder/Modules",
        "$rootFolder/Scripts/Public",
        "$rootFolder/Scripts/Private",
        "$rootFolder/Tests",
        "$rootFolder/Resources/Images",
        "$rootFolder/Resources/Data",
        "$rootFolder/Documentation/Pages"
    )

    # Define the files to create
    $files = @{
        "$rootFolder/Modules" = @("MyModule1.psm1", "MyModule2.psm1", "MyModule3.psm1");
        "$rootFolder/Scripts/Public" = @("Get-Something.ps1", "Set-Something.ps1", "Remove-Something.ps1");
        "$rootFolder/Scripts/Private" = @("Invoke-Something.ps1", "Test-Something.ps1", "Write-Something.ps1");
        "$rootFolder/Scripts" = @("Main.ps1");
        "$rootFolder/Tests" = @("MyModule1.Tests.ps1", "MyModule2.Tests.ps1", "MyModule3.Tests.ps1");
        "$rootFolder/Resources/Images" = @("Image1.png", "Image2.png", "Image3.png");
        "$rootFolder/Resources/Data" = @("Data1.csv", "Data2.csv", "Data3.csv");
        "$rootFolder/Documentation" = @("Readme.md", "License.md");
        "$rootFolder/Documentation/Pages" = @("Page1.md", "Page2.md", "Page3.md");
    }

    # Create folders
    foreach ($folder in $folders) {
        if (-not (Test-Path -Path $folder)) {
            New-Item -Path $folder -ItemType Directory -Force | Out-Null
        }
    }

    # Create files
    foreach ($folder in $files.Keys) {
        foreach ($file in $files[$folder]) {
            $filePath = Join-Path -Path $folder -ChildPath $file
            if (-not (Test-Path -Path $filePath)) {
                New-Item -Path $filePath -ItemType File -Force | Out-Null
            }
        }
    }

    Write-Output "File structure created successfully."

}