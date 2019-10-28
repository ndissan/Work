# Description:
# This script will delete multiple files on a local machine or a 
# file share using the UNC path in the delete-files.csv.
#

#This is the csv file that contains the full path to the 
#files that you want to delete
$files = Import-csv "C:\scripts\U-Drive_Project\u-drives-to-delete.csv"
$deleted = @()
foreach ($file in $files.path) {
    Remove-Item -Path $file -force
    $deleted += $file
}

write-host -foregroundcolor yellow "Delete action" $file "Complete"
$deleted | Out-file -FilePath "C:\scripts\U-Drive_Project\output.csv"