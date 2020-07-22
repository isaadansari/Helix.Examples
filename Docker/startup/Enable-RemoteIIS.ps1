Add-WindowsFeature web-mgmt-service
powershell New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1 -Force

net user kamruz "Q2w3e4r5t6y!" /add
Add-LocalGroupMember -Group administrators -Member kamruz
restart-Service wmsvc
