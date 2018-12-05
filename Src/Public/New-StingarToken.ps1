function New-StingarToken {

    <#
    .SYNOPSIS
        Requests a Stingar token
    .DESCRIPTION
        Requests a token and saves in memory for use during the current session
    .EXAMPLE
        PS C:\> New-StingarToken -Endpoint https://public-cif-stingar.security.duke.edu/
        This command will request a token from https://public-cif-stingar.security.duke.edu for all future commands
    #>

    [CmdletBinding()]
    param (

        # The URL to a valid stingar endpoint
        [Parameter( Mandatory )]
        [string]
        $Endpoint

    )

    begin {

        Set-StrictMode -Version 2.0

        $ErrorActionPreference = "Stop"

        $RestAPI = New-StingarRestAPI -Endpoint $Endpoint

    }

    process {


    }

    end {

    }
}