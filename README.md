# PSProject
The intent of PSProject is to standarize the process of building a PowerShell Project.

## Requirements
|    Reccomended    |     *Minimum*      |
| ----------------- | ------------------ |
| PowerShell v7.0+  |  *PowerShell v5.1* |
| Visual Studio Code | *PowerShell ISE* |
| Text | *Text* |

## Useful Tools
The following tools are recommended when developing a PowerShell Project:
- PSScriptAnalyzer
- PowerShell-Beautifier
- Pester


### Modules
```powershell
Install-Module -Name PSScriptAnalyzer
Install-Module -Name PowerShell-Beautifier
Install-Module -Name Pester
```

#### PSScriptAnalyzer
[PSScriptAnalyzer](https://www.powershellgallery.com/packages/PSScriptAnalyzer/1.23.0 "PowerShell Gallery - PSScriptAnalyzer 1.23.0") provides script analysis and checks for potential code defects in the scripts by applying a group of built-in or customized rules on the scripts being analyzed.

```powershell
# The best practice is to run:
Invoke-ScriptAnalyzer C:\temp\Myfile.ps1 -Recurse

# Review the results, and ensure that:
# All Errors are corrected or addressed in your documentation.
# All Warnings are reviewed, and addressed where applicable.
```

#### PowerShell-Beautifier
[PowerShell-Beautifier](https://github.com/DTW-DanWard/PowerShell-Beautifier "PowerShell-Beautifier on GitHub") is a whitespace reformatter and code cleaner for Windows PowerShell and PowerShell Core (all OSes).

```powershell
# File must be saved first.
# Two spaces is the default indent step, to use a tab:
Edit-DTWBeautifyScript C:\temp\MyFile.ps1 -IndentType Tabs
```

#### Using Pester
[Pester](https://github.com/Pester/Pester "Pester on GitHub") is the ubiquitous test and mock framework for PowerShell. Save this code example in a file named `Get-Planet.Tests.ps1`, and run `Invoke-Pester Get-Planet.Tests.ps1`, or just press `F5` in VSCode.
```powershell
BeforeAll {
    # your function
    function Get-Planet ([string]$Name='*')
    {
        $planets = @(
            @{ Name = 'Mercury' }
            @{ Name = 'Venus'   }
            @{ Name = 'Earth'   }
            @{ Name = 'Mars'    }
            @{ Name = 'Jupiter' }
            @{ Name = 'Saturn'  }
            @{ Name = 'Uranus'  }
            @{ Name = 'Neptune' }
        ) | foreach { [PSCustomObject]$_ }

        $planets | where { $_.Name -like $Name }
    }
}

# Pester tests
Describe 'Get-Planet' {
  It "Given no parameters, it lists all 8 planets" {
    $allPlanets = Get-Planet
    $allPlanets.Count | Should -Be 8
  }

  Context "Filtering by Name" {
    It "Given valid -Name '<Filter>', it returns '<Expected>'" -TestCases @(
      @{ Filter = 'Earth'; Expected = 'Earth' }
      @{ Filter = 'ne*'  ; Expected = 'Neptune' }
      @{ Filter = 'ur*'  ; Expected = 'Uranus' }
      @{ Filter = 'm*'   ; Expected = 'Mercury', 'Mars' }
    ) {
      param ($Filter, $Expected)

      $planets = Get-Planet -Name $Filter
      $planets.Name | Should -Be $Expected
    }

    It "Given invalid parameter -Name 'Alpha Centauri', it returns `$null" {
      $planets = Get-Planet -Name 'Alpha Centauri'
      $planets | Should -Be $null
    }
  }
}
```