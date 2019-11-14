Import-Module PowerClashRoyale

$CurrentWar = Get-ClashRoyaleClanCurrentWar -ClanTag "PRGPJPLY"

ForEach ($Participant in $CurrentWar.participants) {
    #Write-Host $Participant
    If ($Participant.battlesPlayed -lt "3") {
        Write-Host "$($Participant.Name) has only done $($Participant.battlesPlayed) collection battles"
    }
}
$Time = $CurrentWar.collectionEndTime
$EndTime = $Time.Split(".")[0]

$WarCollectionEnd = [datetime]::parseexact($EndTime, 'yyyyMMddThhmmss', $null)

$StartDate=(GET-DATE)

$left = NEW-TIMESPAN –Start $StartDate –End $WarCollectionEnd

Write-Host "Your clan only has $($left.Hours) hour and $($left.Minutes) minutes till War Collection Day ends" -ForegroundColor DarkRed -BackgroundColor Cyan