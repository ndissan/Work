Import-Module ActiveDirectory -Force
$groupfile = Import-csv "C:\scripts\GroupProblems\mastersheet.csv"

Foreach ($group in $groupfile) {
    $onpremaccess = $group.onpremsg
    $365access = $group.o365access
    $365group = $group.o365group
    foreach ($group in $onpremaccess) {
        
        
        Get-ADGroup -Identity $onpremaccess -Properties Name, ManagedBy | Select-object Name,@{label="ManagedBy";expression={[string]($_.managedby | foreach {$_.tostring().split("/")[-1]})}}| Export-Csv "C:\scripts\GroupProblems\groupowners.csv" -NoTypeInformation 
        Sleep -Seconds 1
        $ownerimport = Import-csv "C:\scripts\GroupProblems\groupowners.csv" 
        Get-ADUser $ownerimport.managedby | Select name | Export-csv "C:\scripts\GroupProblems\groupownersfixed.csv" -NoTypeInformation
        Import-csv "C:\scripts\GroupProblems\groupownersfixed.csv" | foreach{
            Set-DistributionGroup -Identity $365access -ManagedBy $_.name
        }
    Sleep -Seconds 1
    }
    
}



