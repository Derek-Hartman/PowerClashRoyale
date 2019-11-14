<#
.Synopsis
    list Details of the current War

.EXAMPLE
    Get-ClashRoyaleClanCurrentWar -ClanTag "PRGPJPLY"

.EXAMPLE
    Get-ClashRoyaleClanCurrentWar -Token "YourToken" -ClanTag "PRGPJPLY"

.NOTES
   Modified by: Derek Hartman
   Date: 11/10/2019

#>

Function Get-ClashRoyaleClanCurrentWar {
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
		    "Clan" = "https://api.clashroyale.com/v1/clans/%23$($ClanTag)/currentwar"
	    }

	    $ClanDetails = Invoke-RestMethod -Method GET -Uri $Uri.Clan -Headers @{
		    'authorization' = "Bearer $Token"
		    'Content-Type'           = 'application/json'
	    }

	    ForEach ($ClanDetail in $ClanDetails) {
		    $Clan = $ClanDetail | Select-Object -Property *
		    $ClanProperties = @{
			    state             = $Clan.state
			    collectionEndTime = $Clan.collectionEndTime
			    clan              = $Clan.clan
			    participants      = $Clan.participants
		    }
	        $obj = New-Object -TypeName PSObject -Property $ClanProperties
	        Write-Output $obj
        }
    }
}