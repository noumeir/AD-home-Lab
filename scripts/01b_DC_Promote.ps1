# Run on DC01 after it restarts, as Administrator. Installs AD DS + DNS and creates the forest corp.lab. The server restarts itself.
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
$dsrm = Read-Host "Choose a Directory Services Restore Mode (DSRM) password" -AsSecureString
Install-ADDSForest -DomainName "corp.lab" -DomainNetbiosName "CORP" -InstallDns -SafeModeAdministratorPassword $dsrm -Force
