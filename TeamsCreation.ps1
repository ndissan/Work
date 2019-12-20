#Function to create any channels as specified in the document
function Create-Channel
{   
   param (   
             $ChannelName,$GroupId
         )   
    Process
    {
        try
            {
                $teamchannels = $ChannelName -split ";" 
                if($teamchannels)
                    {
                    foreach($newchannel in $teamchannels)
                        {
                        New-TeamChannel -GroupId $GroupId -DisplayName $newchannel
                    }
                }
            }
        Catch
            {
            }
    }
}
#Function to Add Users to the Team
function Add-Users
{   
    param(   
             $Users,$GroupId,$CurrentUsername,$Role
          )   
    Process
    {
        
        try{
                $teamusers = $Users -split ";" 
                if($teamusers)
                {
                    for($j =0; $j -le ($teamusers.count - 1) ; $j++)
                    {
                        if($teamusers[$j] -ne $CurrentUsername)
                        {
                            Add-TeamUser -GroupId $GroupId -User $teamusers[$j] -Role $Role
                        }
                    }
                }
            }
        Catch
            {
            }
        }
}
#Function to Create the Team itself
function Create-NewTeam
{   
   param (   
             $ImportPath
         )   
  Process
    {
        Import-Module MicrosoftTeams
        $cred = Get-Credential
        $username = $cred.UserName
        Connect-MicrosoftTeams -Credential $cred
        $teams = Import-Csv -Path $ImportPath
        #$MailNickName = $teams.TeamName
        foreach($team in $teams)
        {
            $getteam= get-team |where-object { $_.displayname -eq $team.TeamName}
            If($getteam -eq $null)
            {
                Write-Host "Start creating the team: " $team.TeamName
                $group = New-Team -MailNickName ($team.TeamName -replace " ","") -displayname $team.TeamName -Visibility $team.TeamType
                Write-Host "Creating channels..."
                Create-Channel -ChannelName $team.ChannelName -GroupId $group.GroupId
                Write-Host "Adding team members..."
                Add-Users -Users $team.Members -GroupId $group.GroupId -CurrentUsername $username  -Role Member 
                Write-Host "Adding team owners..."
                Add-Users -Users $team.Owners -GroupId $group.GroupId -CurrentUsername $username  -Role Owner
                #Write-Host "Setting MailNickName..."
                #Sleep 3
                #Set-Team -GroupID $group.GroupId -MailNickName $team.TeamName
                Write-Host "Completed creating the team: " $team.TeamName
                $team=$null
            }
         }
    }
}

#Specify path and name of file
#Column Headers in CSV as follows: TeamName, TeamType(Private or Public), ChannelName, Owners, Members
#ChannelName, Owners, and Members should all be separated by ';'
Create-NewTeam -ImportPath "C:\scripts\TeamsCreation.csv"


