<#
.SYNOPSIS
	This script unlocks a secure configuration file.
.DESCRIPTION
	This script unlocks a secure configuration file. It prompts the user for a passphrase
	and decrypts the content of the file using a symmetric key. The decrypted content is
	verified using a hash. If the hash is valid, the configuration becomes readable.
.PARAMETER Path
	The path to the secure configuration file.
.EXAMPLE
	Unlock-SecureConfigFile -Path "C:\MyProject\config.secured.json"
	
	This command will unlock the secure configuration file located at
	C:\MyProject\config.secured.json.
.NOTES
	File Name      : Unlock-SecureConfigFile.psm1
	Author         : Michelle Broussard
	Last Modified  : 2 February 2025
#>
function Unlock-SecureConfigFile {
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

		# Generate the original file name by replacing .secured.json with .json
		$OriginalFileName = $Path -replace '\.secured\.json$','.json'

		# Generate the JSON file
		$DecryptedConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $OriginalFileName

		# Remove the secured file
		Remove-Item -Path $Path
	} else {
		Write-Host "Hash verification failed! Configuration may be tampered with."
		return $null
	}

}
Export-ModuleMember -Function Unlock-SecureConfigFile