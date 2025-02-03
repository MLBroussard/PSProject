# README.md

# PSProject

## Overview
PSProject is a PowerShell module designed to streamline the creation of a structured folder hierarchy for PowerShell projects. It simplifies the setup process by automatically generating the necessary directories and files.

## Features
- Creates a predefined folder structure for PowerShell projects.
- Includes folders for modules, scripts, tests, resources, and documentation.
- Generates a README.md and LICENSE file for the project.

## Installation
To use the PSProject module, you can import it into your PowerShell session:

```powershell
Import-Module -Name "Path\To\PSProject\PSProject.psm1"
```

## Usage
To create a new PowerShell project structure, use the `New-PSProject` function:

```powershell
New-PSProject -Path "Path\To\Your\Project"
```

This command will prompt you for the project name and create the necessary folder structure.

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue for any enhancements or bug fixes.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.