function Get-NextAvailableUpdate {

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False, HelpMessage="JSON source for the update KB articles.")]
    [string] $StartKB = 'https://support.microsoft.com/api/content/asset/4000816',

    [Parameter(Mandatory=$False, HelpMessage="Windows build number.")]
    [ValidateSet('15063','14393','10586','10240')]
    [string] $BUild = '15063',

    [Parameter(Mandatory=$False, HelpMessage="Windows update Catalog Search Filter.")]
    [ValidateSet('x64','x86','Cumulative','Delta',$null)]
    [string[]] $Filter = @( "Cumulative" )

)


##Region Support Routine

Function Select-LatestUpdate {
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Updates
    )
    Begin { 
        $MaxObject = $null
        $MaxValue = [version]::new("0.0")
    }
    Process {
        ForEach ( $Update in $updates ) {
            Select-String -InputObject $Update -AllMatches -Pattern "(\d+\.)?(\d+\.)?(\d+\.)?(\*|\d+)" |
            ForEach-Object { $_.matches.value } |
            ForEach-Object { $_ -as [version] } |
            ForEach-Object { 
                if ( $_ -gt $MaxValue ) { $MaxObject = $Update; $MaxValue = $_ }
            }
        }
    }
    End { 
        $MaxObject | Write-Output 
    }
}


##Find the KB Article Number

Write-Verbose "Downloading $StartKB to retrieve the list of updates."
$kbID = Invoke-WebRequest -Uri $StartKB |
    Select-Object -ExpandProperty Content |
    ConvertFrom-Json |
    Select-Object -ExpandProperty Links |
    Where-Object level -eq 2 |
    Where-Object text -match $BUild |
    Select-LatestUpdate |
    Select-Object -First 1


##Download link from Windows Update

Write-Verbose "Found ID: KB$($kbID.articleID)"
$kbObj = Invoke-WebRequest -Uri "http://www.catalog.update.microsoft.com/Search.aspx?q=KB$($KBID.articleID)" 

$Available_KBIDs = $kbObj.InputFields | 
    Where-Object { $_.type -eq 'Button' -and $_.Value -eq 'Download' } | 
    Select-Object -ExpandProperty  ID


$Available_KBIDs | out-string | write-verbose

$kbGUIDs = $kbObj.Links | 
    Where-Object ID -match '_link' |
    Where-Object { $_.OuterHTML -match ( "(?=.*" + ( $Filter -join ")(?=.*" ) + ")" ) } |
    ForEach-Object { $_.id.replace('_link','') } |
    Where-Object { $_ -in $Available_KBIDs }
    Write-Host "$($kbID.text)"

}
