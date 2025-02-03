<#
.SYNOPSIS
    This script creates a folder structure for a PowerShell project.
.DESCRIPTION
    This script creates a folder structure for a PowerShell project. The folder
    structure includes the following folders:
    - Modules: Contains the PowerShell modules for the project.
    - Scripts\Public: Contains the public scripts for the project.
    - Scripts\Private: Contains the private scripts for the project.
    - Tests: Contains the test scripts for the project.
    - Resources\Images: Contains the images used in the project.
    - Resources\Data: Contains the data files used in the project.
    - Documentation\Pages: Contains the documentation pages for the project.
    It also creates some default files in the folders, such as module files, script
    files, test files, image files, data files, and documentation files.
.PARAMETER Name
    The name of the project.
.EXAMPLE
    New-PSProject -Name "MyProject"
    This command will prompt you for the name of the project and create the folder structure.
.NOTES
    File Name      : New-PSProject.ps1
    Author         : Michelle Broussard
    Last Modified  : 2 February 2025
#>
function New-PSProject {
    [CmdletBinding()]
    param(
        [string]$Name
    )

    # Define the root folder
    $rootFolder = $Name
    Write-Verbose "Creating folder structure for project: $rootFolder"

    # Define the folder structure
    $folders = @(
        "$rootFolder\Documentation\Pages",
        "$rootFolder\Resources\Images",
        "$rootFolder\Resources\Data",
        "$rootFolder\Scripts\Public",
        "$rootFolder\Scripts\Private",
        "$rootFolder\Tests"
    )

    # Create folders
    foreach ($folder in $folders) {
        if (-not (Test-Path -Path $folder)) {
            New-Item -Path $folder -ItemType Directory -Force | Out-Null # Suppress output
        }
    }

    $source = "$PSScriptRoot\Modules\*"
    Write-Verbose "Copying files from $source to $rootFolder"
    $destination = "$rootFolder\Modules"
    New-Item -Path $destination -ItemType Directory -Force | Out-Null # Suppress output
    Copy-Item -Path $source -Exclude "PSProject" -Destination $destination -Recurse -Force

    # Create README.md file
    $readmeFile = Join-Path -Path $rootFolder -ChildPath "README.md"
    New-Item -Path $readmeFile -ItemType File -Force | Out-Null # Suppress output

    # Create LICENSE file
    $licenseFile = Join-Path -Path $rootFolder -ChildPath "LICENSE"
    New-Item -Path $licenseFile -ItemType File -Force | Out-Null # Suppress output

    Write-Verbose "FILE STRUCTURE CREATED SUCCESSFULLY"
}