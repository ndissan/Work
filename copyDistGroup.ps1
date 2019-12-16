#import groups
$groupfile = Import-csv "C:\scripts\mastersheet_new.csv"

#Get the on-prem security group, export to csv (Group name (pre-Windows 2000))
#specify the *already created* group in o365
#specify name of mailbox/distribution list to grant access to




Foreach ($group in $groupfile) {
    $onpremaccess = $group.onpremsg
    $365group = $group.o365group
    foreach ($group in $onpremaccess) {
        Get-ADGroupMember -Identity $onpremaccess | Select Name | Export-CSV "C:\scripts\groups.csv" -NoTypeInformation
        Sleep -Seconds 3
        New-DistributionGroup -Name $365group -Type "Distribution"
        Import-CSV "C:\scripts\GroupProblems\groups.csv" | foreach{
            Add-DistributionGroupMember -Identity $365group -member $_.Name
            write-host "Added Group Members"
        }
    }
    #Sleep -Seconds 3
    #Add-MailboxPermission -Identity $365group -User $365access -AccessRights FullAccess -InheritanceType All
    #Add-RecipientPermission -Identity $365group -Trustee $365access -AccessRights SendAs -Confirm:$false
}
