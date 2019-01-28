function New-StingarToken {

    <#
    .SYNOPSIS
        Requests a STINGAR token
    .DESCRIPTION
        Requests a token and saves in memory for use during the current session
    .EXAMPLE
        PS C:\> New-StingarToken -Endpoint https://public-cif-stingar.security.duke.edu/
        This command will request an authentication token from https://public-cif-stingar.security.duke.edu.
        If received, this token will be cached locally, until expired, for all further requests 
        to this endpoint. 
    #>

    [CmdletBinding()]
    param (

        # The URL to a valid stingar endpoint
        [Parameter( Mandatory )]
        [string]
        $Endpoint

    )

    begin {

        $ErrorActionPreference = "Stop"

        $RestAPI = New-StingarRestAPI -Endpoint $Endpoint

    }

    process {


    }

    end {

    }
}