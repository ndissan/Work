Write-Host 'Connecting to Office 365 PowerShell' -ForegroundColor Yellow
$O365Cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365cred -Authentication Basic -AllowRedirection
Write-Host 'Connection to Office 365 Successful' -ForegroundColor Yellow
Write-Host 'Importing Office 365 PSSession' -ForegroundColor Yellow
Import-PSSession $Session -DisableNameChecking |Out-Null
Write-Host 'PSSession Importing has been Completed' -ForegroundColor Green

