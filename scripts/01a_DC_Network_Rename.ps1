# Run on the SERVER VM as Administrator (PowerShell). Sets a static IP and renames the server to DC01, then restarts.
$nic = Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1
Write-Host "Using adapter: $($nic.Name)"
New-NetIPAddress -InterfaceAlias $nic.Name -IPAddress 10.10.10.10 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias $nic.Name -ServerAddresses 127.0.0.1
Rename-Computer -NewName DC01 -Restart
