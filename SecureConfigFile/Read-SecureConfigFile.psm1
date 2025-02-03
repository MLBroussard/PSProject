<#
.SYNOPSIS
	This script reads a secure configuration file.
.DESCRIPTION
	This script reads a secure configuration file. It prompts the user for a passphrase
	and decrypts the content of the file using a symmetric key. The decrypted content is
	verified using a hash. If the hash is valid, the configuration is returned.
.PARAMETER Path
	The path to the secure configuration file.
.EXAMPLE
	$Config = Read-SecureConfigFile -Path "C:\MyProject\config.secured.json"
	
	This command will read the secure configuration file located at
	C:\MyProject\config.secured.json and return the configuration and store it in the
	$Config variable.
.NOTES
	File Name      : Read-SecureConfigFile.psm1
	Author         : Michelle Broussard
	Last Modified  : 2 February 2025
#>
function Read-SecureConfigFile {
	[CmdletBinding()]
	param(
		[string]$Path
	)

	# Prompt the user for a passphrase
	$Passphrase = Read-Host -AsSecureString "Enter the passphrase for decryption"

	# Convert the secure string to plain text
	$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Passphrase)
	$PlainTextPassphrase = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

	# Read the secure JSON file
	$SecureConfig = Get-Content -Path $Path | ConvertFrom-Json

	# Extract encrypted data
	$EncryptedBytes = [Convert]::FromBase64String($SecureConfig.Encrypted)

	# Generate the same AES key
	$Key = (New-Object Security.Cryptography.Rfc2898DeriveBytes -ArgumentList $PlainTextPassphrase,(1..16))
	$AES = New-Object System.Security.Cryptography.AesManaged
	$AES.Key = $Key.GetBytes(32)
	$AES.IV = $Key.GetBytes(16)

	# Decrypt the content
	$Decryptor = $AES.CreateDecryptor()
	$DecryptedBytes = $Decryptor.TransformFinalBlock($EncryptedBytes,0,$EncryptedBytes.Length)
	$AES.Dispose()

	$DecryptedConfigJson = [System.Text.Encoding]::UTF8.GetString($DecryptedBytes)
	$DecryptedConfig = $DecryptedConfigJson | ConvertFrom-Json

	# Verify the hash
	$HashAlgorithm = New-Object System.Security.Cryptography.SHA256Managed
	$HashBytes = $HashAlgorithm.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($DecryptedConfigJson))
	$HashString = [BitConverter]::ToString($HashBytes) -replace '-'

	if ($HashString -eq $SecureConfig.Hash) {
		Write-Host "Hash verified! Configuration is intact."
		return $DecryptedConfig
	} else {
		Write-Host "Hash verification failed! Configuration may be tampered with."
		return $null
	}
}
Export-ModuleMember -Function Read-SecureConfigFile