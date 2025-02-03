<#
.SYNOPSIS
	This script locks a configuration file using encryption.
.DESCRIPTION
	This script locks a configuration file using encryption. It prompts the user for
	a passphrase and encrypts the content of the file using a symmetric key. The
	encrypted content is stored in a new JSON file with the extension .secured.json.
	The original file is renamed with the extension .json.bak and hidden. The original
	file is moved to a secure location.
.PARAMETER Path
	The path to the configuration file.
.EXAMPLE
	Lock-ConfigFile -Path "C:\MyProject\config.json"

	This command will lock the configuration file located at
	C:\MyProject\config.json.
.NOTES
	File Name      : Lock-ConfigFile.psm1
	Author         : Michelle Broussard
	Last Modified  : 2 February 2025
#>
function Lock-ConfigFile {
	[CmdletBinding()]
	param(
		[string]$Path
	)

	# Prompt the user for a passphrase
	$Passphrase = Read-Host -AsSecureString "Enter a passphrase for encryption"

	# Convert the secure string to plain text
	$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Passphrase)
	$PlainTextPassphrase = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

	# Read the settings from the JSON file
	$Config = Get-Content -Path $Path | ConvertFrom-Json

	# Convert to JSON
	$ConfigJson = $Config | ConvertTo-Json -Depth 10

	# Hash the content (SHA256)
	$HashAlgorithm = New-Object System.Security.Cryptography.SHA256Managed
	$HashBytes = $HashAlgorithm.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ConfigJson))
	$HashString = [BitConverter]::ToString($HashBytes) -replace '-'

	# Encrypt the config file using a symmetric key
	$Key = (New-Object Security.Cryptography.Rfc2898DeriveBytes -ArgumentList $PlainTextPassphrase,(1..16))
	$AES = New-Object System.Security.Cryptography.AesManaged
	$AES.Key = $Key.GetBytes(32)
	$AES.IV = $Key.GetBytes(16)

	$Encryptor = $AES.CreateEncryptor()
	$EncryptedBytes = $Encryptor.TransformFinalBlock([System.Text.Encoding]::UTF8.GetBytes($ConfigJson),0,$ConfigJson.Length)
	$AES.Dispose()

	# Store the hash and encrypted content in a JSON file
	$SecureConfig = @{
		Hash = $HashString
		Encrypted = [Convert]::ToBase64String($EncryptedBytes)
	}

	# Generate the secured file name
	$SecuredFileName = [System.IO.Path]::ChangeExtension($Path,".secured.json")

	$SecureConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $SecuredFileName

	# Rename the original file
	$PathBackup = $Path -replace '\.json','.json.bak'
	Rename-Item -Path $Path -NewName $PathBackup

	# Hide the original file
	$PathBackup = Get-Item -Path $PathBackup
	$PathBackup.Attributes = $PathBackup.Attributes -bor [System.IO.FileAttributes]::Hidden

	# Move the original file to a secure location
	# $PathBackup | Move-Item -Destination $env:USERPROFILE # Researched moving a file to a secure location

}
Export-ModuleMember -Function Lock-ConfigFile