kill -processname LTSVC -Force -ErrorAction SilentlyContinue
kill -processname LTSvcMon -Force -ErrorAction SilentlyContinue
kill -processname LTTray -Force -ErrorAction SilentlyContinue

Stop-Service -Name 'LTService' -Force -ErrorAction SilentlyContinue
Stop-Service -Name 'LTSVCMon' -Force -ErrorAction SilentlyContinue

Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'ID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'ClientID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'LocationID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'MAC' -ErrorAction SilentlyContinue

Start-Service -Name 'LTSVCMon'
Start-Service -Name 'LTService'
