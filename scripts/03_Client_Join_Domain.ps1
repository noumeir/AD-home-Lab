# Run on the Windows 10/11 CLIENT VM as Administrator. Both VMs must be on the same VirtualBox Internal Network.
$nic = Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1
New-NetIPAddress -InterfaceAlias $nic.Name -IPAddress 10.10.10.20 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias $nic.Name -ServerAddresses 10.10.10.10
Rename-Computer -NewName WS01 -Force
Add-Computer -DomainName "corp.lab" -Credential (Get-Credential -Message "Enter CORP\Administrator") -Restart
