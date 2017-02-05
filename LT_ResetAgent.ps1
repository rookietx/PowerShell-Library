##Kill Processes 
kill -processname LTSVC -Force
kill -processname LTSvcMon -Force
kill -processname LTTray -Force

##STOP Services 
Stop-Service -Name 'LTService' -Force -ErrorAction SilentlyContinue
Stop-Service -Name 'LTSVCMon' -Force -ErrorAction SilentlyContinue

##RESET LabTech Agent
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'ID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'ClientID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'LocationID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'MAC' -ErrorAction SilentlyContinue

##START LabTech Services
#Start-Service -Name 'LTService'
#Start-Service -Name 'LTSVCMon'
