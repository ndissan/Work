$UserList = Import-Csv c:\scripts\UserList.csv
$CombinedUsers = @()

ForEach ($User in $UserList) {
    $csuser = get-csuser $User.username 
    $mbuser = get-MailboxLocation $User.username
    $UserResults= [PSCustomObject]@{
        DisplayName = $csuser.DisplayName
        SamAccountName = $csuser.SamAccountName
        HostingProvider = $csuser.HostingProvider
        RegistrarPool = $csuser.RegistrarPool
        MailboxLocationType = $mbuser.MailboxLocationType
    }
    $combinedusers += $UserResults
}
$combinedusers | Export-Csv c:\scripts\Exchange-Skype-Everything.csv -NoType

$combinedusers | Where{($_.MailboxLocationType -ieq "Primary") -and ($_.HostingProvider -ieq "SRV:") } | Export-Csv c:\scripts\ExchangeOnline-SkypeOnPrem.csv -NoType

$CombinedUsers | Where{($_.MailboxLocationType -ieq "ComponentShared") -and ($_.HostingProvider -ieq "sipfed.online.lync.com") } | Export-Csv c:\scripts\ExchangeOnPrem-SkypeOnline.csv -NoType
