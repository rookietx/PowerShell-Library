function Get-VMSnapshotCount {

    param(
        $esxhost,
        $user,
        $pass,
        $vm
        ) 
        
Install-Module -Name VMware.PowerCLI -Scope AllUsers -ea SilentlyContinue | Out-Null

Import-Module VMware.VimAutomation.Core | Out-Null
Connect-VIServer $esxhost -User $user -Password $pass -WarningAction SilentlyContinue -Force | Out-Null
Get-VM * | ?{$_.Name -eq $vm} | Get-snapshot | Select-object VM | Group-Object VM | fl -Property count
}
