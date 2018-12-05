$Root = ( Get-Item $PSScriptRoot ).Parent.Fullname
$ProjectName = Get-ProjectName -Path $Root

Deploy PowerShellModule {

    By PSGalleryModule {
        FromSource "$Root\Src\$ProjectName.psd1"
        To "DukeOIT"
        WithOptions @{
            ApiKey = $env:CI_ONEGET_API_KEY
        }
        Tagged production
    }

    By PSGalleryModule {
        FromSource "$Root\Src\$ProjectName.psd1"
        To "DukeOIT-Test"
        WithOptions @{
            ApiKey = $env:CI_ONEGET_API_KEY
        }
        Tagged test
    }

}