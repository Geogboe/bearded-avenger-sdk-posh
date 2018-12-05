#Requires -Module BuildHelpers

<#
.SYNOPSIS
    This is a setup script which will update directories and file names to strip off premade template values.
.DESCRIPTION
    Outline of all actions taken
    1. Module manifiest values will be updates
    2. Module file names will be updated
    3. A symlink will
.EXAMPLE
    PS C:\> .\Setup.ps1 -ModuleName MyModule
    This will customize this project template with the name MyModule
.INPUTS
    None
.OUTPUTS
    [PSCUstomObject] This script will return a PSCustomObject with the following properties
.NOTES
    General notes
#>

[CmdletBinding( PositionalBinding )]
param (

    # Name of the module being developed with this template
    [Parameter( Mandatory )]
    [ValidateScript({ 
        if ( [bool]( Get-Module -ListAvailable $_ )) { 
        
            throw "Cannot use module name: $_ as a mnodule with that name is already installed" 

        } else { 

            $true 

        }
    })]
    [string]
    $ModuleName,

    # Indicates that a symlink will NOT be created for this module into your module path
    # This symlink is useful so that you can continue to develop this module in it's current workspace
    # will allowing you to import it from anywhere on your system
    [Parameter()]
    [switch]
    $NoSymLink = $false,

    # The path to an alternate module directory
    [Parameter()]
    [ValidateScript( { Test-Path $_ })]
    [string]
    $AlternateModulePath

)

begin {

    DATA LogMessages { 

        ConvertFrom-StringData @'
      
        NotInGitLab = Git project is NOT hosted on gitlab.oit.duke.edu and therefore cannot be set up using this script!
        
'@
    
    }

    Set-StrictMode -Version 2.0

    $ErrorActionPreference = "Stop"

    function Get-GitProjectUrl () {

        # Take a git remote origin url and converts it to a gitlab string
        # This only works with gitlab.oit.duke.edu so make sure we're using that
        # For example, we're going to git a url like this: git@gitlab.oit.duke.edu:gb93/VirusTotalTool.git
        # and convert it to this: https://gitlab.oit.duke.edu/gb93/VirusTotalTool

        $GitProject = [PSCustomObject]@{

            GitUrl         = $null
            IsGitLabDomain = $null
            Domain         = $null
            ProjectPath    = $null
            Url            = $null

        }

        $GitProject.GitUrl = Invoke-Git 'config --get remote.origin.url'
        $GitProject.IsGitLabDomain = $GitProject.GitUrl -match "gitlab\.oit\.duke\.edu"
        $GitProject.Domain = ( $GitProject.GitUrl -split "\:" )[0]
        $GitProject.ProjectPath = ( $GitProject.GitUrl -split "\:" )[1] -replace "\.git"

        if ( !$GitProject.IsGitLabDomain ) {

            throw $LogMessages.NotInGitLab

        }

        $GitProject.Url = "https://gitlab.oit.duke.edu/" + $GitProject.ProjectPath

        return $GitProject

    }

    $ProjectRootDir = ( Get-Item $PSScriptRoot ).Parent

    $NewModule = [PSCustomObject]@{

        Name                  = $null
        Version               = $null
        Guid                  = $null
        Author                = $null
        ModuleSrcDirectory    = $null
        ManifestPath          = $null
        RootModuleFile        = $null
        CreateSymlink         = $null
        UseAltModulePath      = $null
        DefaultModulePaths    = $null
        DefaultUserModulePath = $null
        TargetModulePath      = $null
        ProjectUri            = $null
        ManifestValid         = $null

    }
}

process {

    # Initialize properties
    $NewModule.Name = $ModuleName
    $NewModule.Version = [version]::new( "0.0.1" )
    $NewModule.Guid = ( New-Guid ).Guid
    $NewModule.Author = Invoke-Git -Arguments 'config user.name'
    $NewModule.ModuleSrcDirectory = Join-Path $ProjectRootDir.FullName "Src"
    $NewModule.ManifestPath = Get-PSModuleManifest -Path $ProjectRootDir.FullName
    $NewModule.RootModuleFile = Get-Item -Path "$($NewModule.ModuleSrcDirectory)\*.psm1"
    $NewModule.CreateSymlink = $NoSymLink -eq $false
    $NewModule.UseAltModulePath = [bool]( $AlternateModulePath )
    $NewModule.DefaultModulePaths = $env:PSModulePath -split ";"
    $NewModule.DefaultUserModulePath = $NewModule.DefaultModulePaths | 
        Where-Object { $_ -match "Documents\\WindowsPowerShell\\Modules" } | 
        Select-Object -First 1

    $NewModule.TargetModulePath = if ( $NewModule.UseAltModulePath ) { 

        Resolve-Path $AlternateModulePath 

    } else { 

        $NewModule.DefaultUserModulePath 

    }

    $NewModule.ProjectUri = ( Get-GitProjectUrl ).Url

    # Update the module manifest file name
    if ( -not ( Test-Path $NewModule.ManifestPath )) {

        $NewFileName = $NewModule.Name + ".psd1"
        Write-Host "Setting name of module manifest file to: $NewFileName"
        Rename-Item -Path $NewModule.ManifestPath -NewName $NewFileName
        $NewModule.ManifestPath = Get-PSModuleManifest -Path $ProjectRootDir.FullName

    }

    # Update the root module file name
    if ( $NewModule.RootModuleFile.Name -notmatch $NewModule.Name ) {

        $NewFileName = $NewModule.Name + ".psm1"
        Write-Host "Setting name of root module file to: $NewFileName"
        Rename-Item -Path $NewModule.RootModuleFile -NewName $NewFileName
        $NewModule.RootModuleFile = Get-Item -Path "$NewModule.ModuleSrcDirectory\*.psm1"

    }

    # Update the module manifest root module value
    Write-Host "Updating module manifest with name of root module..."
    Update-Metadata -Path $NewModule.ManifestPath -PropertyName "RootModule" -Value ( $NewModule.Name + ".psm1" )

    # Update the guid
    Write-Host "Updating module manifest with new guid..."
    Update-Metadata -Path $NewModule.ManifestPath -PropertyName "GUID" -Value $NewModule.Guid

    # Update the author
    Write-Host "Updating module manifest with name of author..."
    Update-Metadata -Path $NewModule.ManifestPath -PropertyName "Author" -Value $NewModule.Author

    # Update the project URI
    Write-Host "Updating module manifest with project uri..."
    Update-Metadata -Path $NewModule.ManifestPath -PropertyName "ProjectUri" -Value $NewModule.ProjectUri

    Write-Host "Validating module manifest..."
    if ( -not ( Test-ModuleManifest -Path $NewModule.ManifestPath )) {

        $NewModule.ManifestValid = $false
        throw "Module manifest failed validation. Please investigate manifest file for syntax errors at path: $($NewModule.ManifestPath)"

    }

    $NewModule.ManifestValid = $true

    if ( $NewModule.CreateSymlink ) {

        $SymlinkPath = Join-Path $NewModule.TargetModulePath $NewModule.Name

        if ( -not ( Test-Path $SymlinkPath )) {

            if ( -not $NewModule.UseAltModulePath ) { 

                if (( Read-Host "Create a symlink to this module at path: $SymlinkPath ? ( y/N )" ) -notmatch "y" ) { 

                    Write-Host "No symlink created."; 
                    return

                }
            }

            Write-Host "Creating symlink for module at path: $SymlinkPath..."
            New-Item -ItemType SymbolicLink -Path $SymlinkPath -Target $NewModule.ModuleSrcDirectory | Out-Null

        }
    }



}

end {

    return $NewModule

}