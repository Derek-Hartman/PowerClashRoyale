<#
.Synopsis
    list Players Details from Clash Royale

.EXAMPLE
    Get-ClashRoyalePlayer -PlayerTag "QPPJUGU0"

.EXAMPLE
    Get-ClashRoyalePlayer -Token "YourToken" -PlayerTag "QPPJUGU0"

.NOTES
   Modified by: Derek Hartman
   Date: 11/10/2019

#>

Function Get-ClashRoyalePlayer {
	[CmdletBinding()]

	param(
		[Parameter(Mandatory = $False,
			ValueFromPipeline = $True,
			HelpMessage = "Enter your Token.")]
		[string[]]$Token,
        
        [Parameter(Mandatory = $True,
			ValueFromPipeline = $True,
			HelpMessage = "Enter The Players Tag without the #.")]
		[string[]]$PlayerTag
	)
    
    $RegistryKeyPath = "HKCU:\Software\PowerClashRoyale"
    $Key = Get-ItemProperty -Path $RegistryKeyPath

    If ([string]::IsNullOrEmpty($key.Token)) {
    }
    Else {
        $securestring = convertto-securestring -string ($key.Token)
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securestring)
        $ak = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        $Token = $ak
    }

    If ([string]::IsNullOrEmpty($Token)) {
        Write-Host "-Token needs to be given or set running Set-ClashRoyaleToken function" -ForegroundColor Yellow -BackgroundColor Red
    }
    Else {
	    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	    $Uri = @{
		    "Player" = "https://api.clashroyale.com/v1/players/%23$($PlayerTag)"
	    }

	    $PlayersStats = Invoke-RestMethod -Method GET -Uri $Uri.Player -Headers @{
		    'authorization' = "Bearer $Token"
		    'Content-Type'           = 'application/json'
	    }

	    ForEach ($PlayersStat in $PlayersStats) {
		    $Player = $PlayersStat | Select-Object -Property *
		    $PlayerProperties = @{
			    tag                   = $Player.tag
			    name                  = $Player.name
			    explevel              = $Player.explevel
			    trophies              = $Player.trophies
                bestTrophies          = $Player.bestTrophies
                wins                  = $Player.wins
                losses                = $Player.losses
                battleCount           = $Player.battleCount
                threeCrownWins        = $Player.threeCrownWins
                challengeCardsWon     = $Player.challengeCardsWon
                challengeMaxWins      = $Player.challengeMaxWins
                tournamentCardsWon    = $Player.tournamentCardsWon
                tournamentBattleCount = $Player.tournamentBattleCount
                donations             = $Player.donations
                donationsReceived     = $Player.donationsReceived
                totalDonations        = $Player.totalDonations
                warDayWins            = $Player.warDayWins
                clanCardsCollected    = $Player.clanCardsCollected
                arena                 = $Player.arena
                leagueStatistics      = $Player.leagueStatistics
                badges                = $Player.badges
                achievements          = $Player.achievements
                cards                 = $Player.cards
                currentDeck           = $Player.currentDeck
                currentFavouriteCard  = $Player.currentFavouriteCard
		    }
	        $obj = New-Object -TypeName PSObject -Property $PlayerProperties
	        Write-Output $obj
        }
    }
}