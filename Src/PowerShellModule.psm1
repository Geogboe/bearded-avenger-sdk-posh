# Root Module

# Find all script files within project
$PrivateScripts = Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -Recurse -ErrorAction SilentlyContinue
$PublicScripts = Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Recurse -ErrorAction SilentlyContinue
$ModelScripts = Get-ChildItem -Path "$PSScriptRoot\Models\*.ps1" -Recurse -ErrorAction SilentlyContinue
$Scripts = @($PrivateScripts) + @($PublicScripts) + @($ModelScripts)

# Dot source each script file
foreach ( $Script in $Scripts ) {

    Write-Debug (

        "{0}: Dot sourcing private script file: {1}" -f
        (Get-Date -Format G), $Script.BaseName

    )

    try {

        . $Script.FullName

    }

    catch {

        Write-Error -Message "Failed to import function $($Script.fullname): $_"

    }

}

# Export functions defined in Public scripts
if ( $PublicScripts ) {

    Export-ModuleMember -Function $PublicScripts.BaseName -Alias *

}

# Import localized data file if it exists
Import-LocalizedData -BindingVariable LocalizedData -BaseDirectory $PSScriptRoot\Localized -FileName LocalizedData.psd1 -ErrorAction SilentlyContinue