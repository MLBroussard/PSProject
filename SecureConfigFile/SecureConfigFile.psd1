@{
    # PowerShell module manifest for SecureConfigModule
    ModuleVersion = '1.0.0'
    GUID = 'd3e5f3c1-5b8e-4c5e-9f1e-5e4e5c5f5e5e'
    Author = 'Michelle Broussard'
    CompanyName = 'Your Company Name'
    Copyright = 'Copyright © 2025 Your Company Name'
    Description = 'A module for securely locking, unlocking, and reading configuration files using encryption.'
    FunctionsToExport = @('Lock-ConfigFile', 'Unlock-SecureConfigFile', 'Read-SecureConfigFile')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    RequiredModules = @()
    RequiredAssemblies = @()
    FileList = @('Lock-ConfigFile.psm1', 'Unlock-SecureConfigFile.psm1', 'Read-SecureConfigFile.psm1', 'SecureConfigFile.psm1')
    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Core', 'Desktop')
    RootModule = 'SecureConfigFile.psm1'
}