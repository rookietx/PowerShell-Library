<#PSScriptInfo

.Version
    2.1
.Guid
    477aa3f4-0434-4925-9c92-7323066cceb7
.Author 
    Thomas J. Malkewitz @dotps1
.Tags 
    WannaCry, SMB1, Malware
.ProjectUri
    https://github.com/dotps1/PSFunctions
.ReleaseNotes
    Replaced Write-Warning with Write-Error so it can be caught in a try catch block.
    
#>

<#

.Synopsis
    Tests for WannaCry vulnerabilities.
.Description
    Test for applicable patches to prevent the WannaCry malware.  Tests for SMB1 protocol and component.
.Inputs
    System.String
    Microsoft.Management.Infrastructure.CimSession
.Outputs
    System.Management.Automation.PSCustomObject
.Parameter ComputerName
    System.String
    ComputerName to test.
.Parameter Credential
    System.Management.Automation.PSCredential
    Credential to test with.
.Parameter CimSession
    Microsoft.Management.Infrastructure.CimSession
    CimSession to test.
.Example
    PS C:\> Test-WannaCryVulnerability

    PSComputerName         : myrig
    OperatingSystemCaption : Microsoft Windows 7 Professional
    OperatingSystemVersion : 6.1.7601
    Vulnerable             : False
    AppliedHotFixID        : KB4012212|KB4015546|KB4015549
    SMB1FeatureEnabled     : False
    SMB1ProtocolEnabled    : False
.Example
    PS C:\> Get-ADComputer -Identity workstation | Test-WannaCryVulnerability

    PSComputerName         : workstation
    OperatingSystemCaption : Microsoft Windows 7 Professional
    OperatingSystemVersion : 6.1.7601
    Vulnerable             : True
    AppliedHotFixID        : 
    SMB1FeatureEnabled     : False
    SMB1ProtocolEnabled    : True
.Notes
    Not applicable to windows 10.
.Link
    https://www.redsocks.eu/news/ransomware-wannacry/
.Link
    https://support.microsoft.com/en-us/help/2696547/how-to-enable-and-disable-smbv1,-smbv2,-and-smbv3-in-windows-vista,-windows-server-2008,-windows-7,-windows-server-2008-r2,-windows-8,-and-windows-server-2012
.Link
    https://dotps1.github.io
.Link
    https://www.powershellgallery.com/packages/New-ADUserName
.Link
    https://grposh.github.io

#>
function WannaCry-Checker{

[CmdletBinding(
    DefaultParameterSetName = "ByComputerName"
)]
[OutputType(
    [PSCustomObject]
)]

param (
    [Parameter(
        ParameterSetName = "ByComputerName",
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true
    )]
    [ValidateScript({
        if (Test-Connection -ComputerName $_ -Count 1 -Quiet) {
            return $true
        } else {
            throw "Failed to contact '$_'."
        }
    })]
    [Alias(
        "ComputerName"    
    )]
    [String[]]
    $Name = $env:COMPUTERNAME,

    [Parameter(
        ParameterSetName = "ByComputerName"
    )]
    [System.Management.Automation.PSCredential]
    $Credential = [PSCredential]::Empty,

    [Parameter(
        ParameterSetName = "ByCimSession",
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true
    )]
    [Microsoft.Management.Infrastructure.CimSession[]]
    $CimSession
)

begin {
    $hotFixIDs = @(
        "KB3205409", 
        "KB3210720", 
        "KB3210721", 
        "KB3212646", 
        "KB3213986", 
        "KB4012212", 
        "KB4012213", 
        "KB4012214", 
        "KB4012215", 
        "KB4012216", 
        "KB4012217", 
        "KB4012218", 
        "KB4012220", 
        "KB4012598", 
        "KB4012606", 
        "KB4013198", 
        "KB4013389", 
        "KB4013429", 
        "KB4015217", 
        "KB4015438", 
        "KB4015546", 
        "KB4015547", 
        "KB4015548", 
        "KB4015549"
    )
}

process {
    switch ($PSCmdlet.ParameterSetName) {
        "ByComputerName" { 
            foreach ($nameValue in $Name) {
                try {
                    Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using WMI" -CurrentOperation "Retrieve operating system information" -PercentComplete 20
                    $osInformation = Get-WmiObject -ComputerName $nameValue -Class Win32_OperatingSystem -Property Caption, Version -Credential $Credential -ErrorAction Stop
                } catch {
                    Write-Error -Message "Failed to query WMI on '$nameValue'." -RecommendedAction "Verify WMI access is not being blocked by the firewall."
                    continue
                }

                if ([Version]$osInformation.Version -ge [Version]"10.0.15063") {
                    Write-Error -Message "$($osInformation.Caption) $($osInformation.Version) is not vulnerable to the WannaCry Exploit."
                    continue
                }

                # HotFixes
                Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using WMI" -CurrentOperation "Inventory hotfix information" -PercentComplete 40
                $appliedHotFixID = (Get-WmiObject -ComputerName $nameValue -Class Win32_QuickFixEngineering -Credential $Credential).Where({
                    $_.HotFixID -in $hotFixIDs
                }).HotFixID

                #SMB1 Feature
                Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using WMI" -CurrentOperation "Retrieve SMB1 feature installation status" -PercentComplete 60
                $smb1Feature = Get-WmiObject -ComputerName $nameValue -Class Win32_OptionalFeature -Property InstallState -Filter "Name = 'SMB1Protocol'" -Credential $Credential |
                    Select-Object -ExpandProperty InstallState

                if ($optionalFeature -eq 1) {
                    $smb1FeatureEnabled = $true
                } else {
                    $smb1FeatureEnabled = $false
                }

                #SMB1 Protocol
                Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using WMI" -CurrentOperation "Retrieve SMB1 protocol status" -PercentComplete 80
                $smb1Protocol = Invoke-WmiMethod -ComputerName $nameValue -Class StdRegProv -Name GetDwordValue -ArgumentList @( [uint32]2147483650, "SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters", "SMB1" ) -Credential $Credential |
                    Select-Object -ExpandProperty uValue

                if ($smb1Protocol -eq 0) {
                    $smb1ProtocolEnabled = $false
                } else {
                    $smb1ProtocolEnabled = $true
                }
                
                # Vulnerable?
                Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using WMI" -CurrentOperation "Determine vulnerability status" -PercentComplete 100
                if ($appliedHotFixId.Count -gt 0 -and -not $smb1FeatureEnabled -and -not $smb1ProtocolEnabled) {
                    $vulnerable = $false
                } else {
                    $vulnerable = $true
                }

                $output = [PSCustomObject]@{
                    Vulnerable = $vulnerable
                    AppliedHotFixID = $appliedHotFixId -join "|"
                    SMB1FeatureEnabled = $smb1FeatureEnabled
                    SMB1ProtocolEnabled = $smb1ProtocolEnabled
                }

                Write-Output -InputObject $output | fl
            }
        }
        
        "ByCimSession" {
            foreach ($cimSessionValue in $CimSession) {
                Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using CIM" -CurrentOperation "Retrieve operating system caption" -PercentComplete 20
                $osInformation = Get-CimInstance -CimSession $cimSessionValue -ClassName Win32_OperatingSystem -Property Caption, Version

                if ([Version]$osInformation.Version -ge [Version]"10.0.15063") {
                    Write-Error -Message "$($osInformation.Caption) $($osInformation.Version) is not vulnerable to the WannaCry Exploit."
                    continue
                }

                # HotFixes
                Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using CIM" -CurrentOperation "Inventory hotfix information" -PercentComplete 40
                $appliedHotFixID = (Get-CimInstance -CimSession $CimSession -ClassName Win32_QuickFixEngineering).Where({
                    $_.HotFixID -in $hotFixIDs
                }).HotFixID


                #SMB1 Feature
                Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using CIM" -CurrentOperation "Retrieve SMB1 feature installation status" -PercentComplete 60
                $smb1Feature = Get-CimInstance -CimSession $cimSessionValue -ClassName Win32_OptionalFeature -Property InstallState -Filter "Name = 'SMB1Protocol'" |
                    Select-Object -ExpandProperty InstallState

                if ($optionalFeature -eq 1) {
                    $smb1FeatureEnabled = $true
                } else {
                    $smb1FeatureEnabled = $false
                }

                # SMB1 Protocol
                Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using CIM" -CurrentOperation "Retrieve SMB1 protocol status" -PercentComplete 80
                $smb1Protocol = Invoke-CimMethod -CimSession $cimSessionValue -ClassName StdRegProv -MethodName GetDwordValue -Arguments @{ hDefKey = [uint32]2147483650; sSubKeyName = "SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"; sValueName = "SMB1" } |
                    Select-Object -ExpandProperty uValue

                if ($smb1Protocol -eq 0) {
                    $smb1ProtocolEnabled = $false
                } else {
                    $smb1ProtocolEnabled = $true
                }

                # Vulnerable?
                Write-Progress -Activity "Testing '$nameValue' for WannaCry vulnerabilities using CIM" -CurrentOperation "Determine vulnerability status" -PercentComplete 100
                if ($appliedHotFixId.Count -gt 0 -and -not $smb1FeatureEnabled -and -not $smb1ProtocolEnabled) {
                    $vulnerable = $false
                }

                $output = [PSCustomObject]@{
                    Vulnerable = $vulnerable
                    AppliedHotFixID = $appliedHotFixId -join "|"
                    SMB1FeatureEnabled = $smb1FeatureEnabled
                    SMB1ProtocolEnabled = $smb1ProtocolEnabled
                }

                Write-Output -InputObject $output | fl
            }
        }
    }
}
}
