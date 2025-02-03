[CmdletBinding()]
param()
# main.ps1
Write-Verbose $PSScriptRoot

# Load .\Scripts\Private\New-PSProject.ps1
Import-Module -Name $PSScriptRoot\Modules\PSProject