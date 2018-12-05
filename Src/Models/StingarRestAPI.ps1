New-Module -Name StingarRestAPI -ReturnResult -ScriptBlock {

    <#
        DELETE /tokens?{username,token}	"delete a token or set of tokens"
        GET /	"this message"
        GET /feed?{q,limit,itype,confidence,tags,reporttime}	"filter for a data-set, aggregate and apply respective whitelist"
        GET /help	"this message"
        GET /help/confidence	"get a list of the defined confidence values"
        GET /indicators?{q,limit,indicator,confidence,tags,reporttime}	"search for a set of indicators"
        GET /ping	"ping the router interface"
        GET /search?{q,limit,itype,indicator,confidence,tags,reporttime}	"search for an indicator"
        GET /tokens?{username,token}	"search for a set of tokens"
        GET /u	"browser friendly ui [login with api token]"
        PATCH /token	"update a token"
        POST /indicators	"post indicators to the router"
        POST /tokens	"create a token or set of tokens"
    #>

    class StingarRestAPI {

        [string] $Endpoint

        StingarRestAPI ( $Endpoint ) {

            $this.Endpoint = $Endpoint

        }

        ### Methods
        Get ( [string]$Path, [hashtable]$Params )  {


        }

        Patch () {

        }

        Post () {

        }

        Delete () {

        }

    }

    function New-StingarRestAPI ( $Endpoint ) {

        # create and return an instance of this object
        [StingarRestAPI]::new( $Endpoint )

    }
}