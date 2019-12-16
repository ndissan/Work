$email = Read-Host "Please provide the email address of a Shared Mailbox"
Set-CalendarProcessing -Identity $email -AllowConflicts $true
Set-Mailbox -Identity $email -Type Room
Set-CalendarProcessing -Identity $email -AutomateProcessing AutoAccept
Set-Mailbox -Identity $email -Type Shared
$answer = Read-Host "Would you like to keep or delete non-calendar items (e.g. emails) ( keep / delete )?"
While ("keep","delete" -notcontains $answer) {
	$answer = Read-Host "Would you like to keep or delete non-calendar items (e.g. emails) ( keep / delete )?"
	}
If ($answer -eq 'keep') {
	Set-CalendarProcessing -Identity $email -DeleteNonCalendarItems $false
	Remove-Variable * -ErrorAction SilentlyContinue
	}
ElseIf ($answer -eq 'delete') {
	Set-CalendarProcessing -Identity $email -DeleteNonCalendarItems $true
	Remove-Variable * -ErrorAction SilentlyContinue
	}