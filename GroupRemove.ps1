﻿Import-Csv -Path "C:\scripts\remove.csv" | ForEach-Object {Remove-ADGroupMember -Identity “Office_365_License_F1” -Member $_.’EmailAddresses’ -Confirm:$false}