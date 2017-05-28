<#PSScriptInfo
.Version
    1.4
.Author
    Martyn T. Keigher (@martynkeigher)
.Tags
    win10, version, build, update
.Github URL
    https://github.com/MartynKeigher/PowerShell-Library
.ReleaseNotes 
    1.0 - Initial Release. 
    1.1 - Added Get-CurrentVersion func.
    1.2 - Added Get-NextBuildNumber func.
    1.3 - Added Get-NextUpdateLink func.
    1.4 - Some typos... 
#>

<#
.Description
    More to follow 
.Parameters
    none.
.Exmaple
    PS C:\> Get-Item $env:WinDir\System32\WindowsPowerShell\v1.0\powershell.exe | .\Win10-Updater.ps1; Get-CurrentVersion
.Example
    iwr https://raw.githubusercontent.com/MartynKeigher/PowerShell-Library/master/Win10-Updater.ps1 | iex; Get-CurrentVersion
    iwr https://raw.githubusercontent.com/MartynKeigher/PowerShell-Library/master/Win10-Updater.ps1 | iex; Get-NextBuildNumber
    iwr https://raw.githubusercontent.com/MartynKeigher/PowerShell-Library/master/Win10-Updater.ps1 | iex; Get-Get-NextUpdateLink
   
.Notes
    More to follow
#>

##Function to retreiev the current build/revision of Win10
function Get-CurrentVersion {

$Maj = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMajorVersionNumber).CurrentMajorVersionNumber
$Min = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMinorVersionNumber).CurrentMinorVersionNumber
$Bld = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentBuild).CurrentBuild
$Rev = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' UBR).UBR
$VER = "$Maj.$Min.$Bld.$Rev"
"$VER"

}


##Function to retreiev the next update build/revision number of Win10
function Get-UpdateBuildNumber {

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

Write-Verbose "Downloading $StartKB to retrieve the list of updates."
$kbID = Invoke-WebRequest -Uri $StartKB |
    Select-Object -ExpandProperty Content |
    ConvertFrom-Json |
    Select-Object -ExpandProperty Links |
    Where-Object level -eq 2 |
    Where-Object text -match $BUild |
    Select-LatestUpdate |
    Select-Object -First 1

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


##Function to retreive the URL (for BITS?) of the next available update.
function Get-UpdateLink {

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False, HelpMessage="JSON source for the update KB articles.")]
    [string] $StartKB = 'https://support.microsoft.com/api/content/asset/4000816',

    [Parameter(Mandatory=$False, HelpMessage="Windows build number.")]
    [ValidateSet('15063','14393','10586','10240')]
    [string] $BUild = '15063',

    [Parameter(Mandatory=$False, HelpMessage="Windows update Catalog Search Filter.")]
    [ValidateSet('x64','x86','Cumulative','Delta',$null)]
    [string[]] $Filter = @( "x64" )

)

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

Write-Verbose "Downloading $StartKB to retrieve the list of updates."
$kbID = Invoke-WebRequest -Uri $StartKB |
    Select-Object -ExpandProperty Content |
    ConvertFrom-Json |
    Select-Object -ExpandProperty Links |
    Where-Object level -eq 2 |
    Where-Object text -match $BUild |
    Select-LatestUpdate |
    Select-Object -First 1

Write-Verbose "Found ID: KB$($kbID.articleID)"
$kbObj = Invoke-WebRequest -Uri "http://www.catalog.update.microsoft.com/Search.aspx?q=KB$($KBID.articleID)" 

$Available_KBIDs = $kbObj.InputFields | 
    Where-Object { $_.type -eq 'Button' -and $_.Value -eq 'Download'} | 
    Select-Object -ExpandProperty  ID

$Available_KBIDs | out-string | write-verbose

$kbGUIDs = $kbObj.Links | 
    Where-Object ID -match '_link' |
    Where-Object { $_.OuterHTML -match ( "(?=.*" + ( $filter -join ")(?=.*" ) + ")" ) } |
    ForEach-Object { $_.id.replace('_link','') } |
    Where-Object { $_ -in $Available_KBIDs }

foreach ( $kbGUID in $kbGUIDs )
{
    Write-Verbose "`t`tDownload $kbGUID"
    $Post = @{ size = 0; updateID = $kbGUID; uidInfo = $kbGUID } | ConvertTo-Json -Compress
    $PostBody = @{ updateIDs = "[$Post]" } 
    Invoke-WebRequest -Uri 'http://www.catalog.update.microsoft.com/DownloadDialog.aspx' -Method Post -Body $postBody |
        Select-Object -ExpandProperty Content |
        Select-String -AllMatches -Pattern "(http[s]?\://download\.windowsupdate\.com\/[^\'\""]*)" | 
        Select-Object -Unique |
        ForEach-Object {$_.matches.value}

}
}
