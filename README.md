# PowerShell Module Template

## Table of Contents

<!-- TOC -->

- [PowerShell Module Template](#powershell-module-template)
    - [Table of Contents](#table-of-contents)
    - [Overview](#overview)
    - [How to use this template](#how-to-use-this-template)
    - [Resources](#resources)
    - [Popular Examples](#popular-examples)
    - [Tips and Tricks](#tips-and-tricks)

<!-- /TOC -->

## Overview


## How to use this template

1. Delete any unncessary directories or script that won't be needed in your project
2. Make sure you've at least taken a look at the Powershell best practices and style guide.
3. Recommend installing Posh-Git, InvokeBuild, and BuildHelpers from PowershellGallery. Very useful.
4. Either update all the necessary placeholder values or run .\ModuleHelpers\setup.ps1 with the name of your module to have this done for you.

## Resources

- Good place to start for organizing your code: https://poshcode.gitbooks.io/powershell-practice-and-style/
- Greate collection of popular useful projects: https://github.com/janikvonrotz/awesome-powershell

## Popular Examples

- Usage of tests and src directory: https://github.com/dahlbyk/posh-git
- Good usage of public and private directories, docs, and tests: https://github.com/PowerShell/Polaris

## Tips and Tricks

- Create a symbolic link from your source files your module path. Example: ni ..\DevModules\PatchMonkey-Windows -ItemType SymbolicLink -Target .\PatchMonkey-Windows\.
This allows you to import the module from anywhere on your system without you having. The setup.ps1 script does this for you though.