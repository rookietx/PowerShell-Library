##Disable built-in Win10 Apps
Get-AppxPackage *3dbuilder* | Remove-AppxPackage | Out-Null
Get-AppxPackage *windowsalarms* | Remove-AppxPackage | Out-Null
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage | Out-Null
Get-AppxPackage *windowscamera* | Remove-AppxPackage | Out-Null
Get-AppxPackage *officehub* | Remove-AppxPackage | Out-Null
Get-AppxPackage *skypeapp* | Remove-AppxPackage | Out-Null
Get-AppxPackage *getstarted* | Remove-AppxPackage | Out-Null
Get-AppxPackage *zunemusic* | Remove-AppxPackage | Out-Null
Get-AppxPackage *windowsmaps* | Remove-AppxPackage | Out-Null
Get-AppxPackage *solitairecollection* | Remove-AppxPackage | Out-Null
Get-AppxPackage *bingfinance* | Remove-AppxPackage | Out-Null
Get-AppxPackage *zunevideo* | Remove-AppxPackage | Out-Null
Get-AppxPackage *bingnews* | Remove-AppxPackage | Out-Null
Get-AppxPackage *onenote* | Remove-AppxPackage | Out-Null
Get-AppxPackage *people* | Remove-AppxPackage | Out-Null
Get-AppxPackage *windowsphone* | Remove-AppxPackage | Out-Null
Get-AppxPackage *photos* | Remove-AppxPackage | Out-Null
Get-AppxPackage *windowsstore* | Remove-AppxPackage | Out-Null
Get-AppxPackage *bingsports* | Remove-AppxPackage | Out-Null
Get-AppxPackage *soundrecorder* | Remove-AppxPackage | Out-Null
Get-AppxPackage *xboxapp* | Remove-AppxPackage | Out-Null

##Disable Cortana
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\' -Name 'Windows Search' | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -PropertyType DWORD -Value '0' | Out-Null

##Disable OneDrive
C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall | Out-Null
Start-Sleep -Seconds 30
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\' -Name 'Skydrive' | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Skydrive' -Name 'DisableFileSync' -PropertyType DWORD -Value '1' | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Skydrive' -Name 'DisableLibrariesDefaultSaveToSkyDrive' -PropertyType DWORD -Value '1' | Out-Null 
Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{A52BBA46-E9E1-435f-B3D9-28DAA648C0F6}' -Recurse | Out-Null
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT 
Set-ItemProperty -Path 'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Name 'System.IsPinnedToNameSpaceTree' -Value '0' -ea SilentlyContinue| Out-Null
Remove-PSDrive -Name HKCR
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Skydrive' -Name 'DisableLibrariesDefaultSaveToSkyDrive' -PropertyType DWORD -Value '1' -ea SilentlyContinue | Out-Null 
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowDriveLettersFirst' -PropertyType DWORD -Value '4' -ea SilentlyContinue | Out-Null

## Clean up 'This PC' Explorer window & disable hibernation
Set-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Name 'ThisPCPolicy' -Value 'Hide' -ea SilentlyContinue | Out-Null
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Value '1' -ea SilentlyContinue | Out-Null
New-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt ' -PropertyType DWORD -Value '0' | Out-Null 
taskkill /IM explorer.exe /F | Out-Null
C:\windows\explorer.exe


##Windows Update settings
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' -Name 'DODownloadMode' -Value '0' -ea SilentlyContinue | Out-Null
Set-Service AppIDSvc -StartupType Automatic -ea SilentlyContinue | Out-Null
Set-Service BITS -StartupType Automatic -ea SilentlyContinue | Out-Null
Set-Service wuauserv -StartupType Automatic -ea SilentlyContinue | Out-Null
sc.exe config wuauserv type= own | Out-Null


##Disable needless services
Set-Service AJRouter -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service ALG -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service BDESVC -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service DeviceAssociationService -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service DiagTrack -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service DPS -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service DsmSvc -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service Eaphost -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service EFS -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service Fax -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service FDResPub -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service HomeGroupListener -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service HomeGroupProvider -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service HomeGroupProvider -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service icssvc -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service MSiSCSI -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service PcaSvc -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service QWAVE -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service RetailDemo -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service SensorDataService -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service SensorService -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service SensrSvc -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service SharedAccess -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service SNMPTRAP -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service SSDPSRV -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service SstpSvc -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service svsvc -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service swprv -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service swprv -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service TabletInputService -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service TapiSrv -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service upnphost -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service wbengine -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service wcncsvc -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service WcsPlugInService -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service WdiServiceHost -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service WdiSystemHost -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service WiaRpc -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service WMPNetworkSvc -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service XblAuthManager -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service XblGameSave -StartupType Disabled -ea SilentlyContinue | Out-Null
Set-Service XboxNetApiSvc -StartupType Disabled -ea SilentlyContinue | Out-Null

## Disable Scheduled Tasks:
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Autochk\Proxy" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Bluetooth\UninstallDeviceTask" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Diagnosis\Scheduled" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Maintenance\WinSAT" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Maps\MapsToastTask" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Maps\MapsUpdateTask" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Ras\MobilityManager" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Registry\RegIdleBackup" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Shell\FamilySafetyMonitor" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Shell\FamilySafetyRefresh" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\SystemRestore\SR" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\UPnP\UPnPHostConfig" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\WDI\ResolutionHost" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\WOF\WIM-Hash-Management" -ea SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "\Microsoft\Windows\WOF\WIM-Hash-Validation" -ea SilentlyContinue | Out-Null

##Disable hibernation & enable HIGH powerplan
powercfg -h off
powercfg -SetActive '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'

##Disable restore options 
Disable-ComputerRestore -Drive "C:\"

##Disable Windows 10 First Logon Animation
Set-ItemProperty -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableFirstLogonAnimation' -PropertyType DWORD -Value '0' -ea SilentlyContinue | Out-Null

##Reduce menu show delay
Set-ItemProperty -Path 'HKEY_CURRENT_USER\ControlPanel\Desktop' -Name 'MenuShowDelay' -Value '0' -ea SilentlyContinue | Out-Null

##Disable IE First Run Wizard
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'Internet Explorer' -ea SilentlyContinue | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer' -Name 'Main' -ea SilentlyContinue | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main' -Name DisableFirstRunCustomize -PropertyType DWORD -Value '1' -ea SilentlyContinue | Out-Null

##Disable SMB1
dism /online /Disable-Feature /FeatureName:SMB1Protocol /NoRestart

##END##
