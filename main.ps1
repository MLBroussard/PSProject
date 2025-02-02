. .\Set-Config.ps1
. .\Get-Config.ps1

Set-Config ".\employees.json"
Start-Sleep -Seconds 2
Get-Config ".\employees.secured.json"