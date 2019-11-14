Import-Module PowerClashRoyale

$CurrentWar = Get-ClashRoyaleClanCurrentWar -ClanTag "PRGPJPLY"

$Clan = Get-ClashRoyaleClan -ClanTag "PRGPJPLY"

$Compare = Compare-Object -ReferenceObject $CurrentWar.participants.name -DifferenceObject $Clan.memberList.name

ForEach ($Member in $Compare) {
    If ($Member.SideIndicator -eq "=>") {
        Write-Host "$($Member.InputObject) is not participating in the war"
    }
}
