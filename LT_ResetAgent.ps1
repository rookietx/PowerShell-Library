##Kill Agent
kill -processname LTSVC, LTSVCMon, LTTray -Force -ErrorAction SilentlyContinue

##Reset Agent
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'ID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'ClientID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'LocationID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'MAC' -ErrorAction SilentlyContinue

##Restart Agent
Restart-Service -Name 'LTService'
Restart-Service -Name 'LTSVCMon'
