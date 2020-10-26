Write-Host 'Connecting to Office 365 PowerShell' -ForegroundColor Yellow
$O365Cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365cred -Authentication Basic -AllowRedirection
Write-Host 'Connection to Office 365 Successful' -ForegroundColor Yellow
Write-Host 'Importing Office 365 PSSession' -ForegroundColor Yellow
Import-PSSession $Session -DisableNameChecking |Out-Null
Write-Host 'PSSession Importing has been Completed' -ForegroundColor Green



# Turn on logging
$LogFile = "FixOffice365GroupSubscriptions-$(Get-Date -Format yyyymmdd-HH-mm-ss)"

Start-Transcript -Path $PSScriptRoot\$LogFile.log -NoClobber

# Get list of all Office 365 Groups
#$groupname = Read-Host -Prompt 'Enter the name of the O365 Group'
#$groups = Get-UnifiedGroup -Identity $Groupname

#bulklist
$groups = Import-csv C:\users\b81670\Downloads\ExportData.csv


# Uncomment this to test on one group
#$groups = Get-UnifiedGroup -Identity "Group_Name_or_Email_Address"

foreach ($group in $groups) {

Try {
#Enable subscribe new members
Set-UnifiedGroup -identity $group.name -AutoSubscribeNewMembers 

# Get list of all members
$members = Get-UnifiedGroupLinks -Identity $group.Name -LinkType Members
Write-Host "Members of ""$($group.DisplayName)"":" -ForegroundColor Green
Write-Host ($members | Format-Table | Out-String)

# Get list of all subscribers
$subscribers = Get-UnifiedGroupLinks -Identity $group.Name -LinkType Subscribers
Write-Host "Subscribers of ""$($group.DisplayName)"":" -ForegroundColor Green
Write-Host ($subscribers | Format-Table | Out-String)

# Subscribe all members not subscribed
Write-Host "Subscribing all members not currently subscribed..."
foreach ($member in $members) {
If ($member.Name -notin $subscribers.Name) {
Write-Host "Adding $($member.Name)."
Add-UnifiedGroupLinks -Identity $group.Name -LinkType Subscribers -Links $member.Name
} else {
Write-Host "$($member.Name) is already subscribed."
}
}

# Done!
Write-Host "Done!" -ForegroundColor Green
} Catch {
Write-Host "There was an error subscribing all users in ""$($group.DisplayName)""." -ForegroundColor Red
Write-Host $($Error[0].Exception) -ForegroundColor Red
Continue
}
}

# End logging
Stop-Transcript