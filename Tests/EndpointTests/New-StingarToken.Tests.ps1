Import-Module PoshSTINGAR -Force
InModuleScope PoshSTINGAR {

    Describe "Endpoint Tests" -Tags Debug {

        Context "Get a token" {

            New-StingarToken -Endpoint https://public-cif-stingar.security.duke.edu/ | Out-Host
        }

    }
}