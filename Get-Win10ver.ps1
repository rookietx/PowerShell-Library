<#PSScriptInfo
.Version
    1.0
.Author
    Martyn T. Keigher (@martynkeigher)
.Tags
    esx, iso
.Github URL
    https://github.com/MartynKeigher/PowerShell-Library
.ReleaseNotes 
    1.0 - Initial Release.  
#>


<#
.Description
    Returns the FULL build (including rev number) of the Win10 OS. 
.Parameters
    win10, version, build
.Exmaple
    PS C:\> Get-Item $env:WinDir\System32\WindowsPowerShell\v1.0\powershell.exe | .\Get-Win10ver.ps1; Get-Win10ver
.Example
    iwr https://raw.githubusercontent.com/MartynKeigher/PowerShell-Library/master/Get-Win10ver.ps1 | iex; Get-Win10ver
.Notes
    Requires at least PoSH v3.
#>

function Get-Win10ver {

$v = New-Object –TypeName PSObject
$v | Add-Member –MemberType NoteProperty –Name Major –Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMajorVersionNumber).CurrentMajorVersionNumber
$v | Add-Member –MemberType NoteProperty –Name Minor –Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMinorVersionNumber).CurrentMinorVersionNumber
$v | Add-Member –MemberType NoteProperty –Name Build –Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentBuild).CurrentBuild
$v | Add-Member –MemberType NoteProperty –Name Revision –Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' UBR).UBR
$v = "$($v.Major).$($v.Minor).$($v.Build).$($v.Revision)"
"$v"

}
