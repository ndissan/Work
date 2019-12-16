Import-Csv C:\scripts\CERT-Migration\sharepoint-sites.csv | foreach-object {
    $Sharepoint = Set-SPOUser -Site $_.sharepoint -LoginName b81670@andersencorp.com -IsSiteCollectionAdmin $false
}