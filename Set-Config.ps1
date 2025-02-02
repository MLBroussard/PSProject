function Set-Config {
    param (
        [string]$ConfigFilePath
    )
    
    # Prompt the user for a passphrase
    $Passphrase = Read-Host -AsSecureString "Enter a passphrase for encryption"
    
    # Convert the secure string to plain text
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Passphrase)
    $PlainTextPassphrase = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    
    # Read the settings from the file
    $Config = Get-Content -Path $ConfigFilePath | ConvertFrom-Json
    
    # Convert to JSON
    $ConfigJson = $Config | ConvertTo-Json -Depth 10
    
    # Hash the content (SHA256)
    $HashAlgorithm = New-Object System.Security.Cryptography.SHA256Managed
    $HashBytes = $HashAlgorithm.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ConfigJson))
    $HashString = [BitConverter]::ToString($HashBytes) -replace '-'
    
    # Encrypt the config file using a symmetric key
    $Key = (New-Object Security.Cryptography.Rfc2898DeriveBytes -ArgumentList $PlainTextPassphrase, (1..16))
    $AES = New-Object System.Security.Cryptography.AesManaged
    $AES.Key = $Key.GetBytes(32)
    $AES.IV = $Key.GetBytes(16)
    
    $Encryptor = $AES.CreateEncryptor()
    $EncryptedBytes = $Encryptor.TransformFinalBlock([System.Text.Encoding]::UTF8.GetBytes($ConfigJson), 0, $ConfigJson.Length)
    $AES.Dispose()
    
    # Store the hash and encrypted content in a JSON file
    $SecureConfig = @{
        Hash      = $HashString
        Encrypted = [Convert]::ToBase64String($EncryptedBytes)
    }
    
    # Generate the secured file name
    $SecuredFileName = [System.IO.Path]::ChangeExtension($ConfigFilePath, ".secured.json")
    
    $SecureConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $SecuredFileName
}
