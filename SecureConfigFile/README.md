# Secure Configuration Module

## Overview
The Secure Configuration Module provides a set of PowerShell functions to securely lock, unlock, and read configuration files using encryption. This module ensures that sensitive configuration data is protected through encryption and can only be accessed with a valid passphrase.

## Files

### 1. Lock-ConfigFile.psm1
This file contains the `Lock-ConfigFile` function, which locks a configuration file by encrypting its content using a symmetric key. It prompts the user for a passphrase, hashes the content, and stores the encrypted data in a new JSON file with the extension `.secured.json`. The original file is renamed with the extension `.json.bak` and hidden.

### 2. Unlock-SecureConfigFile.psm1
This file contains the `Unlock-SecureConfigFile` function, which unlocks a secure configuration file by decrypting its content. It prompts the user for a passphrase, verifies the hash of the decrypted content, and if valid, returns the configuration. It also generates the original file name and removes the secured file.

### 3. Read-SecureConfigFile.psm1
This file contains the `Read-SecureConfigFile` function, which reads a secure configuration file. It prompts the user for a passphrase, decrypts the content, verifies the hash, and returns the configuration if the hash is valid.

### 4. SecureConfigModule.psd1
This is the module manifest file for the PowerShell module. It defines the module's metadata, including the module version, author, and the functions exported by the module.

## Usage
To use the functions in this module, you can import the module into your PowerShell session and call the desired function:

```powershell
Import-Module SecureConfigModule

# Lock a configuration file
Lock-ConfigFile -Path "C:\Path\To\Your\Config.json"

# Unlock a secure configuration file
Unlock-SecureConfigFile -Path "C:\Path\To\Your\Config.secured.json"

# Read a secure configuration file
$Config = Read-SecureConfigFile -Path "C:\Path\To\Your\Config.secured.json"
```

## Author
Michelle Broussard

## Last Modified
2 February 2025

## License
The PSProject is licensed under the [MIT license](LICENSE).