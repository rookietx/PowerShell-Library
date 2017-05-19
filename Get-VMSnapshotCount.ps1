function Get-VMSnapshotCount {

    param(
        $esxhost,
        $user,
        $pass,
        $vm
        ) 
        
Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -Scope AllUsers -Force | Out-Null
Install-Module -Name VMware.PowerCLI –Scope AllUsers | Out-Null

Start-Sleep -s 10

Import-Module VMware.PowerCLI | Out-Null
Connect-VIServer $esxhost -User $user -Password $pass -WarningAction SilentlyContinue -Force | Out-Null
Get-VM * | ?{$_.Name -eq $vm} | Get-snapshot | Select-object VM | Group-Object VM | fl -Property count
}
