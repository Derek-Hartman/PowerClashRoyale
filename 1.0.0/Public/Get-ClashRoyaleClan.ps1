<#
.Synopsis
    list Players Details from Clash Royale

.EXAMPLE
    Get-ClashRoyaleClan -ClanTag "PRGPJPLY"

.EXAMPLE
    Get-ClashRoyaleClan -Token "YourToken" -ClanTag "PRGPJPLY"

.NOTES
   Modified by: Derek Hartman
   Date: 11/10/2019

#>

Function Get-ClashRoyaleClan {
	[CmdletBinding()]

	param(
		[Parameter(Mandatory = $False,
			ValueFromPipeline = $True,
			HelpMessage = "Enter your Token.")]
		[string[]]$Token,
        
        [Parameter(Mandatory = $True,
			ValueFromPipeline = $True,
			HelpMessage = "Enter The Clan Tag without the #.")]
		[string[]]$ClanTag
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
		    "Clan" = "https://api.clashroyale.com/v1/clans/%23$($ClanTag)"
	    }

	    $ClanDetails = Invoke-RestMethod -Method GET -Uri $Uri.Clan -Headers @{
		    'authorization' = "Bearer $Token"
		    'Content-Type'           = 'application/json'
	    }

	    ForEach ($ClanDetail in $ClanDetails) {
		    $Clan = $ClanDetail | Select-Object -Property *
		    $ClanProperties = @{
			    tag               = $Clan.tag
			    name              = $Clan.name
			    type              = $Clan.type
			    description       = $Clan.description
                badgeId           = $Clan.badgeId
                clanScore         = $Clan.clanScore
                clanWarTrophies   = $Clan.clanWarTrophies
                location          = $Clan.location 
                requiredTrophies  = $Clan.requiredTrophies
                donationsPerWeek  = $Clan.donationsPerWeek
                clanChestStatus   = $Clan.clanChestStatus
                clanChestLevel    = $Clan.clanChestLevel
                clanChestMaxLevel = $Clan.clanChestMaxLevel
                members           = $Clan.members
                memberList        = $Clan.memberList
		    }
	        $obj = New-Object -TypeName PSObject -Property $ClanProperties
	        Write-Output $obj
        }
    }
}