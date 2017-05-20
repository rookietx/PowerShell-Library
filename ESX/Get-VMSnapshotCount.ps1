function Get-VMSnapshotCount {

    param(
        [string]$esxhost,
        [string]$user,
        [string]$pass,
        [string]$vm = $env:COMPUTERNAME
        ) 
        
Import-Module VMware.PowerCLI -wa SilentlyContinue | Out-Null
Connect-VIServer -Server $esxhost -User $user -Password $pass -wa SilentlyContinue -Force | Out-Null
(Get-Snapshot -VM $vm).count
}
