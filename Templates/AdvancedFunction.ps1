function Verb-Noun {

    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Example of how to use this cmdlet
    .INPUTS
        Inputs to this cmdlet (if any)
    .OUTPUTS
        Output from this cmdlet (if any)
    .NOTES
        General notes
    #>

    [CmdletBinding()]
    param (

        # Parameter help description
        [Parameter(AttributeValues)]
        [ParameterType]
        $ParameterName

    )

    begin {

        Set-StrictMode -Version 2.0
        
        $ErrorActionPreference = "Stop"

    }

    process {

    }

    end {

    }
}