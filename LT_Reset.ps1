taskkill /IM ltsvc* /f /T
taskkill /IM lttray* /f /T

Stop-Service -Name "LTService" -Force -ErrorAction SilentlyContinue
Stop-Service -Name "LTSVCMon" -Force -ErrorAction SilentlyContinue

Remove-ItemProperty -Path "HKLM:\Software\LabTech\Service" -Name "ID" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\Software\LabTech\Service" -Name "ClientID" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\Software\LabTech\Service" -Name "LocationID" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\Software\LabTech\Service" -Name "MAC" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\Software\LabTech\Service" -Name "ServerPassword" -ErrorAction SilentlyContinue

Set-ItemProperty -Path "HKLM:\Software\LabTech\Service" -Name "ServerPassword" -Value 'RL1ZY/o51CvU6KGsYQr1eA=='

Start-Service -Name "LTService"
Start-Service -Name "LTService"
