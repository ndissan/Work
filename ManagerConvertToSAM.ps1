Import-Csv -Path C:\Scripts\getmanagersPAM.csv |
foreach {
 $user = Get-ADUser -Identity $_.samaccountname -Properties Manager
 $_ | Add-Member -MemberType NoteProperty -Name 'Manager' -Value $user.Manager
 $_ | Export-CSV -append C:\scripts\managersexport3.csv
}
 
 
Import-Csv -path "C:\scripts\managersexport3.csv" | Foreach {
	Get-ADUser -Identity $_.manager  | Select-Object -ExpandProperty SamAccountName | Out-File -append C:\scripts\managersexport4.csv
}