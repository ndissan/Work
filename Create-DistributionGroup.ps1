Import-Module ActiveDirectory
Write-Host 'Connecting to Office 365 PowerShell' -ForegroundColor Yellow
$O365Cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365cred -Authentication Basic -AllowRedirection 
Write-Host 'Connection to Office 365 Successful' -ForegroundColor Yellow
Write-Host 'Importing Office 365 PSSession' -ForegroundColor Yellow
Import-PSSession $Session -DisableNameChecking | Out-Null
Write-Host 'PSSession Importing has been Completed' -ForegroundColor Green


$Session2 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://BPMNPWEXC03.andersencorp.com/PowerShell/ -Authentication Kerberos -Credential $O365Cred 
Import-PSSession $Session2 -DisableNameChecking

$Dist = Read-Host -Prompt 'Input name of distribution group'
$DistAlias = Read-Host -Prompt 'Input desired alias of distributiongroup'
$DistAliasAddress = $DistAlias+"@andersencorp.com" 
$ManagedBy = Read-Host -Prompt 'Input a##### of owner @andersencorp.com'
$DistMailAddress = $DistAlias + "@andersencorp.mail.onmicrosoft.com"


New-DistributionGroup -Name $Dist -PrimarySMTPAddress $DistAliasAddress -ManagedBy $ManagedBy -CopyOwnerToMember


New-ADObject -name $Dist -Type Contact -path "OU=Contacts_For_Groups_in_O365,OU=Contacts for O365 Groups,OU=Security Groups,OU=Groups,OU=IT,OU=Corporate,DC=andersencorp,DC=com" -OtherAttributes @{
            'mail'=$DistMailAddress;
            'proxyAddresses'=$DistMailAddress;
            'displayname'=$Dist
            }


Write-Output "Waiting for Domain Controller Sync"

Sleep 30

Enable-Mailcontact -Identity $Dist -ExternalEmailAddress $DistAliasAddress


