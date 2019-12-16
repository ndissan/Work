# Get all members of the GroupB.
Foreach ($User In Get-ADGroupMember -Identity "Office_365_License_F1")
{
#Write-Host $User.SamAccountName
    # If they are a 'MemberOf' GroupA
    If ((Get-ADUser $User.SamAccountName -Properties MemberOf).MemberOf -Match "Office_365_License_E3")
    {
        # Remove that user from GroupA
        Remove-ADGroupMember -Identity "Office_365_License_E3" -Members $User.SamAccountName -Confirm:$false
       #Write-Host $User.SamAccountName
    }
}