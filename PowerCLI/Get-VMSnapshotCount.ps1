<#PSScriptInfo
.Version
    1.1
.Author
    Martyn T. Keigher (@martynkeigher)
.Tags
    esx, snapshots
.Github URL
    https://github.com/MartynKeigher/PowerShell-Library
.ReleaseNotes 
    1.0 - Initial Release.
    1.1 - Edited output for monitor/ingest purposes.
#>


<#
.Description
    Returns the number of snapshots currently live on the VM the script is ran on
.Parameters
    esxhost, user, pass
.Exmaple
    PS C:\> Get-Item $env:WinDir\System32\WindowsPowerShell\v1.0\powershell.exe | .\Get-VMSnapshotCount.ps1 -esxhost 192.168.10.3 -user root -pass P@ssw0rd
.Example
    iwr https://raw.githubusercontent.com/MartynKeigher/PowerShell-Library/master/PowerCLI/Get-VMSnapshotCount.ps1 | iex; Get-VMSnapshotCount -esxhost 192.168.10.3 -user root -pass P@ssw0rd
.Notes
    Requires the VMWare.PowerCLI to be loaded.
.LINK
    PowerCLI module setup guide: https://blogs.vmware.com/PowerCLI/2017/04/powercli-install-process-powershell-gallery.html
.LINK
    Powershell Gallery: https://www.powershellgallery.com/packages/VMware.PowerCLI/6.5.1.5377412
#>

function Get-VMSnapshotCount {

    param(
        [string]$esxhost,
        [string]$user,
        [string]$pass,
        [string]$vm = $env:COMPUTERNAME
        ) 
        
Import-Module VMware.VimAutomation.Core -wa SilentlyContinue | Out-Null
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope AllUsers -confirm:$false -wa SilentlyContinue| Out-Null
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Scope AllUsers -confirm:$false -wa SilentlyContinue | Out-Null
Set-PowerCLIConfiguration -DisplayDeprecationWarnings $false -Scope AllUsers -confirm:$false -wa SilentlyContinue | Out-Null
Connect-VIServer -Server $esxhost -User $user -Password $pass -wa SilentlyContinue -Force -wa SilentlyContinue | Out-Null
$count = (Get-Snapshot -VM $vm).count
"Count: $count"
}
