<#PSScriptInfo
.Version
    1.0
.Author
    Martyn T. Keigher (@martynkeigher)
.Tags
    esx, datastore, space, low
.Github URL
    https://github.com/MartynKeigher/PowerShell-Library
.ReleaseNotes 
    1.0 - Initial Release.
    
#>

<#
.Description
    Returns the name & percentage of a datastore with low disk space (<30%)
.Parameters
    esxhost, user, pass
.Exmaple
    PS C:\> Get-Item $env:WinDir\System32\WindowsPowerShell\v1.0\powershell.exe | .\Get-DatastoreSpaceCheck.ps1 -esxhost 192.168.10.3 -user root -pass P@ssw0rd
.Example
    iwr https://raw.githubusercontent.com/MartynKeigher/PowerShell-Library/master/PowerCLI/Get-DatastoreSpaceCheck.ps1 | iex; Get-DatastoreSpaceCheck -esxhost 192.168.10.3 -user root -pass P@ssw0rd
.Notes
    Requires the VMWare.PowerCLI module to be installed.
.LINK
    PowerCLI module setup guide: https://blogs.vmware.com/PowerCLI/2017/04/powercli-install-process-powershell-gallery.html
.LINK
    Powershell Gallery: https://www.powershellgallery.com/packages/VMware.PowerCLI/6.5.1.5377412
#>

function Get-DatastoreSpaceCheck {

    param(
        [string]$esxhost,
        [string]$user,
        [string]$pass
        ) 
        
Import-Module VMware.VimAutomation.Core | Out-Null
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope AllUsers -confirm:$false | Out-Null
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Scope AllUsers -confirm:$false | Out-Null
Set-PowerCLIConfiguration -DisplayDeprecationWarnings $false -Scope AllUsers -confirm:$false | Out-Null
Connect-VIServer -Server $esxhost -User $user -Password $pass -wa SilentlyContinue -Force | Out-Null
New-VIProperty -Name PercentFree -ObjectType Datastore -Value {"{0:N2}" -f ($args[0].FreeSpaceMB/$args[0].CapacityMB*100)+'% free'} -Force | Out-Null
Get-Datastore | ?{$_.PercentFree -le 30} | ft -HideTableHeaders Name,PercentFree
}
