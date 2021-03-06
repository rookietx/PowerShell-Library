<#PSScriptInfo
.Version
    1.1
.Author
    Martyn T. Keigher (@martynkeigher)
.Tags
    win10, version, build
.Github URL
    https://github.com/MartynKeigher/PowerShell-Library
.ReleaseNotes 
    1.0 - Initial Release. 
    1.1 - Removed PSObject req.
#>


<#
.Description
    Returns the FULL build (including rev number) of the Win10 OS. 
.Parameters
    none.
.Exmaple
    PS C:\> Get-Item $env:WinDir\System32\WindowsPowerShell\v1.0\powershell.exe | .\Get-Win10ver.ps1; Get-Win10ver
.Example
    iwr https://raw.githubusercontent.com/MartynKeigher/PowerShell-Library/master/Get-Win10ver.ps1 | iex; Get-Win10ver
.Notes
    Requires at least PoSH v3.
#>

function Get-Win10ver {

$Maj = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMajorVersionNumber).CurrentMajorVersionNumber
$Min = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMinorVersionNumber).CurrentMinorVersionNumber
$Bld = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentBuild).CurrentBuild
$Rev = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' UBR).UBR
$VER = "$Maj.$Min.$Bld.$Rev"
"$VER"

}
