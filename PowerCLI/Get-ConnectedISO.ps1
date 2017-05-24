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
    Returns the name (and datastore) of a connected ISO, if one exists on the VM.
.Parameters
    esxhost, user, pass
.Exmaple
    PS C:\> Get-Item $env:WinDir\System32\WindowsPowerShell\v1.0\powershell.exe | .\Get-ConnectedISO.ps1 -esxhost 192.168.10.3 -user root -pass P@ssw0rd
.Example
    iwr https://raw.githubusercontent.com/MartynKeigher/PowerShell-Library/master/PowerCLI/Get-ConnectedISO.ps1 | iex; Get-ConnectedISO -esxhost 192.168.10.3 -user root -pass P@ssw0rd
.Notes
    Requires the VMWare.PowerCLI module to be installed.
.LINK
    PowerCLI module setup guide: https://blogs.vmware.com/PowerCLI/2017/04/powercli-install-process-powershell-gallery.html
.LINK
    Powershell Gallery: https://www.powershellgallery.com/packages/VMware.PowerCLI/6.5.1.5377412
#>

function Get-ConnectedISO {

    param(
        [string]$esxhost,
        [string]$user,
        [string]$pass,
        [string]$vm = $env:COMPUTERNAME
        ) 
        
Import-Module VMware.VimAutomation.Core | Out-Null
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope AllUsers -confirm:$false | Out-Null
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Scope AllUsers -confirm:$false | Out-Null
Set-PowerCLIConfiguration -DisplayDeprecationWarnings $false -Scope AllUsers -confirm:$false | Out-Null
Connect-VIServer -Server $esxhost -User $user -Password $pass -wa SilentlyContinue -Force | Out-Null
$iso = (Get-VM | ?{$_.Name -eq '$vm'} | Get-CDDrive | ?{$_.IsoPath -ne $null} |  Select-Object -ExpandProperty IsoPath)
"$iso"
}
