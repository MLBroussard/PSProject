# This is PSProjectStructureExample.Tests.ps1

Import-Module Pester

Describe "Build-PSProject" {

    BeforeAll {
        # Mock Read-Host to provide a consistent project name
        Mock -CommandName Read-Host -MockWith { return "TestProject" }

        # Clean up any existing test directories
        if (Test-Path "TestProject") {
            Remove-Item -Path "TestProject" -Recurse -Force
        }

        # Run the function to create the project structure
        . $PSScriptRoot\Build-PSProjectStructure.ps1
        Build-PSProject
    }

    AfterAll {
        # Cleanup test environment
        if (Test-Path "TestProject") {
            Remove-Item -Path "TestProject" -Recurse -Force
        }
    }

    It "Creates the root project folder" {
        Test-Path "TestProject" | Should -BeTrue
    }

    It "Creates the expected folder structure" {
        $expectedFolders = @(
            "TestProject/Modules",
            "TestProject/Scripts/Public",
            "TestProject/Scripts/Private",
            "TestProject/Tests",
            "TestProject/Resources/Images",
            "TestProject/Resources/Data",
            "TestProject/Documentation/Pages"
        )

        foreach ($folder in $expectedFolders) {
            Test-Path $folder | Should -BeTrue
        }
    }

    It "Creates the expected files in the folder structure" {
        $expectedFiles = @{
            "TestProject/Modules" = @("MyModule1.psm1", "MyModule2.psm1", "MyModule3.psm1");
            "TestProject/Scripts/Public" = @("Get-Something.ps1", "Set-Something.ps1", "Remove-Something.ps1");
            "TestProject/Scripts/Private" = @("Invoke-Something.ps1", "Test-Something.ps1", "Write-Something.ps1");
            "TestProject/Scripts" = @("Main.ps1");
            "TestProject/Tests" = @("MyModule1.Tests.ps1", "MyModule2.Tests.ps1", "MyModule3.Tests.ps1");
            "TestProject/Resources/Images" = @("Image1.png", "Image2.png", "Image3.png");
            "TestProject/Resources/Data" = @("Data1.csv", "Data2.csv", "Data3.csv");
            "TestProject/Documentation" = @("Readme.md", "License.md");
            "TestProject/Documentation/Pages" = @("Page1.md", "Page2.md", "Page3.md");
        }

        foreach ($folder in $expectedFiles.Keys) {
            foreach ($file in $expectedFiles[$folder]) {
                $filePath = Join-Path -Path $folder -ChildPath $file
                Test-Path $filePath | Should -BeTrue
            }
        }
    }

    It "Displays a success message" {
        # Capture the output of Build-PSProject
        $output = Build-PSProject

        # Assert the output message
        $output | Should -Be "File structure created successfully."
    }

}
