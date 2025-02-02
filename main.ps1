. .\Lock-ConfigFile.ps1
. .\Read-SecureConfigFile.ps1
. .\Unlock-SecureConfigFile.ps1

# Lock the configuration file
Lock-ConfigFile -Path .\config.json

# Read the secured configuration file
Read-SecureConfigFile -Path .\config.secured.json

# Unlock the secured configuration file
Unlock-SecureConfigFile -Path .\config.secured.json