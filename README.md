# PoshSTINGAR

## Table of Contents
- [PoshSTINGAR](#poshstingar)
    - [Table of Contents](#table-of-contents)
    - [Project Overview](#project-overview)
    - [How to Install](#how-to-install)
    - [Basic Usage](#basic-usage)
    - [Roadmap](#roadmap)
    - [Build From Source](#build-from-source)
    - [Contributing](#contributing)
    - [Contact](#contact)

## Project Overview

This module provides functions to interfaces with the STINGAR REST API.
See https://github.com/csirtgadgets/bearded-avenger/wiki about the details of this project.

## How to Install

Eventually, this module will be available via PowerShellGallery, after which you can install it like this:
```powershell
Install-Module -Name PoshSTINGAR -Repository PSGallery -Force -Scope CurrentUser0
```

For the moment, simple clone the code locally and add the module to your module path like this:
```powershell
git clone git@github.com:Geogboe/bearded-avenger-sdk-posh.git
cd .\bearded-avenger-sdk-posh
Import-Module .\Src\PoshSTINGAR.psd1 -Force

# Optionally, if you don't want to clone directly into your module path, create a symbolic link
$MyModulePath = "$env:HOME\Documents\WindowsPowerShell\Modules"
New-Item -ItemType SymbolicLink -Path "$MyModulePath\PoshSTINGAR" -Target ".\Src"
Import-Module PoshSTINGAR -Force
```

## Basic Usage

```powershell
Import-Module PoshSTINGAR -Force
Get-Command -Module PoshSTINGAR
```

## Roadmap

- Add support for /GET Search and /GET Filter paths
- Add support for remaining paths
- Create a contribution guide
- Create a build from source guide
- Create PSGallery deployment and build process

## Build From Source

WIP...

## Contributing

WIP...

## Contact

George Bowen - george.bowen@duke.edu