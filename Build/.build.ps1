#Requires -Module Pester, PSScriptAnalyzer, BuildHelpers, InvokeBuild, PlatyPS, posh-git


param (

    [switch]$Force = $false

)

Enter-Build {

    $ProjectRoot = ( Get-Item $BuildRoot ).Parent.FullName
    $ScriptAnalyzerRulesDir = Join-Path $ProjectRoot "Rules"
    $BuildDir = Join-Path $ProjectRoot "Build"
    $PSDeployDir = Join-Path $ProjectRoot "Deploy"
    $DocsDir = Join-Path $ProjectRoot "Docs"
    $SrcDir = Join-Path $ProjectRoot "Src"
    $PesterTestDir = Join-Path $ProjectRoot "Tests\UnitTests"
    $ModuleManifestPath = Get-PSModuleManifest -Path $ProjectRoot
    $ModuleName = Get-ProjectName $ProjectRoot
    $BuildEnvironment = Get-BuildEnvironment -Path $ProjectRoot

}

task Analyze {

    Write-Build blue "Running PSScriptAnalyzer against rules in directory: $ScriptAnalyzerRulesDir..."
    Invoke-ScriptAnalyzer -Path $SrcDir -CustomRulePath $ScriptAnalyzerRulesDir -IncludeDefaultRules -Severity Error

} -If { [bool]( Get-ChildItem -Path $ScriptAnalyzerRulesDir\*.ps1 ) }

task Test {

    Write-Build blue "Running Pester tests against tests in directory: $PesterTestDir..."
    Invoke-Pester -Script $PesterTestDir -Show Fails

} -If { [bool]( Get-ChildItem -Path "$PesterTestDir\*.ps1" )}

task GenerateDocs {

    Write-Build blue "Generating docs for module into docs directory: $DocsDir..."
    Import-Module $ModuleName -Force
    New-MarkdownHelp -Module $ModuleName -OutputFolder $DocsDir -WithModulePage -ErrorAction SilentlyContinue -Encoding ([System.Text.Encoding]::utf8) | ForEach-Object {
        Write-Build blue " - created file: $($_.Name)"
    }

} -If { ( Get-GitStatus ).HasUntracked -OR ( Get-GitStatus ).HasIndex -OR ( Get-GitStatus ).HasWorking  } # only if there untracked files or staged changes

task UpdateManifest {

    Write-Build blue "Getting commits tagged with #changelog..."
    $ChangeLogCommits = Invoke-git -Arguments 'log --pretty=format:"-%s @%an-%ci-%s" --grep="#changelog"'

    if ( -not ( [string]::IsNullOrEmpty( $ChangeLogCommits ))) {

        Write-Build blue "Updating release notes..."
        $CurrentReleaseNotes = Get-Metadata -Path $ModuleManifestPath -PropertyName "ReleaseNotes"
        $UpdatedReleaseNotes = $ChangeLogCommits + $CurrentReleaseNotes
        Update-Metadata -Path $ModuleManifestPath -PropertyName "ReleaseNotes" -Value $UpdatedReleaseNotes

    }

    $NextVersion = Get-NextNugetPackageVersion -Name VirusTotalTool -PackageSourceUrl https://oneget.oit.duke.edu/nuget/Powershell
    Update-Metadata -Path $ModuleManifestPath -PropertyName "ModuleVersion" -Value $NextVersion
    $Version = Get-Metadata -Path $ModuleManifestPath
    Write-Build blue "Module version incremented to: $Version"

} -If { ( Get-GitStatus ).HasUntracked -OR ( Get-GitStatus ).HasIndex -OR ( Get-GitStatus ).HasWorking -OR ( Get-GitStatus ).AheadBy -gt 0 } # only if there untracked files or staged changes

task CommitChanges {

    Invoke-Git -Arguments "add $ProjectRoot --ignore-errors"
    Invoke-Git 'commit -m "updates module manifest version and release notes #auto_commit"'

} -If { ( Get-GitStatus ).HasUntracked -OR ( Get-GitStatus ).HasIndex -OR ( Get-GitStatus ).HasWorking } # Only if there are untracked files or staged files

task PushChanges {

    if ( !$Force ) {

        if (( Read-Host "Push changes? (Y/n)" ) -notmatch "n" ) {
            # continue
        } else {
            break
        }
    }

    & git push

} -If {( Get-GitStatus ).AheadBy -gt 0 }

task . Analyze, Test, GenerateDocs, UpdateManifest, CommitChanges, PushChanges