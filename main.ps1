[CmdletBinding()]
param()
# main.ps1
Write-Verbose $PSScriptRoot

# Load .\Scripts\Private\New-PSProject.ps1
. $PSScriptRoot\Scripts\Private\New-PSProject.ps1

New-PSProject -Verbose