# Run on DC01 as CORP\Administrator. Reads ..\data\users.csv relative to this script.
Import-Module ActiveDirectory
$domain = Get-ADDomain
$base = $domain.DistinguishedName
$root = "OU=CorpLab,$base"

function New-OuIfMissing($name, $path) {
    $dn = "OU=$name,$path"
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$dn'")) {
        New-ADOrganizationalUnit -Name $name -Path $path -ProtectedFromAccidentalDeletion $false
        Write-Host "Created OU $dn"
    }
}
New-OuIfMissing "CorpLab" $base
foreach ($n in "Users","Computers","Groups") { New-OuIfMissing $n $root }

$pw = Read-Host "Initial password for the new users (must meet complexity rules)" -AsSecureString
Import-Csv (Join-Path $PSScriptRoot "..\data\users.csv") | ForEach-Object {
    $sam = ("{0}.{1}" -f $_.FirstName, $_.LastName).ToLower()
    $grp = "GG_$($_.Department)"
    if (-not (Get-ADGroup -Filter "Name -eq '$grp'")) {
        New-ADGroup -Name $grp -GroupScope Global -GroupCategory Security -Path "OU=Groups,$root"
        Write-Host "Created group $grp"
    }
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$sam'")) {
        New-ADUser -Name "$($_.FirstName) $($_.LastName)" -GivenName $_.FirstName -Surname $_.LastName `
            -SamAccountName $sam -UserPrincipalName "$sam@$($domain.DNSRoot)" `
            -Department $_.Department -Title $_.Title -Path "OU=Users,$root" `
            -AccountPassword $pw -ChangePasswordAtLogon $true -Enabled $true
        Write-Host "Created user $sam"
    }
    Add-ADGroupMember -Identity $grp -Members $sam
}
Get-ADUser -Filter * -SearchBase $root -Properties Department | Select-Object Name, SamAccountName, Department | Format-Table
