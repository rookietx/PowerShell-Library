##Download + Install node.js

$workfolder = "C:\windows\temp\Ruby"
New-Item $workfolder -type directory -ErrorAction SilentlyContinue | Out-Null 
Write-Host "Downloading node.JS v6.9.5 (LTS) ..." -ForegroundColor Cyan
$webclient = New-Object System.Net.WebClient
$url = "https://nodejs.org/dist/v6.9.5/node-v6.9.5-x64.msi"
$file = $workfolder + "\nodejs695.msi"
$webclient.DownloadFile($url,$file)
Write-Host "Installing node.JS v6.9.5 (LTS) ..." -ForegroundColor Cyan
msiexec /qn /i $file
Write-Host "Installed node.JS v6.9.5 (LTS)!" -ForegroundColor Green



##Download + Install Ruby v2.2.4

Write-Host "Downloading Ruby v2.2.4 ..." -ForegroundColor Cyan
$webclient = New-Object System.Net.WebClient
$url = "https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.6-x64.exe"
$file = $workfolder + "\ruby226.exe"
$webclient.DownloadFile($url,$file)
Write-Host "Installing Ruby v2.2.6..." -ForegroundColor Cyan
$args = '/verysilent /dir="C:\Ruby226" /tasks="assocfiles,modpath"'
Start-Process -Filepath $file -ArgumentList $args | Out-Null
Write-Host "Installed Ruby v2.2.6!" -ForegroundColor Green



##Download + Extract RubyDevkit

Write-Host "Downloading Ruby DevKit ..." -ForegroundColor Cyan
$webclient = New-Object System.Net.WebClient
$url = "https://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe"
$file = $workfolder + "\RubyDevKit.exe"
$webclient.DownloadFile($url,$file)
Write-Host "Extracting Ruby DevKit ..." -ForegroundColor Cyan
$args = '-y -bd -o"C:\RubyDevKit" > nul'
Start-Process -Filepath $file -ArgumentList $args -Wait | Out-Null
Write-Host "Extracted Ruby Development Kit!" -ForegroundColor Green
ri $workfolder -Recurse -Force
Write-Host "All done!!" -ForegroundColor Green
