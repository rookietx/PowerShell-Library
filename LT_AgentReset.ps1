kill -processname LTSVC -Force -ErrorAction SilentlyContinue
kill -processname LTSvcMon -Force -ErrorAction SilentlyContinue
kill -processname LTTray -Force -ErrorAction SilentlyContinue

Stop-Service -Name 'LTService' -Force -ErrorAction SilentlyContinue
Script-Sleep -s 3
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'ID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'ClientID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'LocationID' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'MAC' -ErrorAction SilentlyContinue

Set-ItemProperty -Path 'HKLM:\Software\LabTech\Service' -Name 'ServerPassword' -Value 'MV2UJ1vycEyaYwlvQP078A=='


Start-Sleep -s 5
Start-Service -Name 'LTService'
