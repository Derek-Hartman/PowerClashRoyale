<#
.Synopsis
    list Players Details from Clash Royale

.EXAMPLE
    Get-ClashRoyaleClanWarLog -ClanTag "PRGPJPLY"

.EXAMPLE
    Get-ClashRoyaleClanWarLog -Token "YourToken" -ClanTag "PRGPJPLY"

.NOTES
   Modified by: Derek Hartman
   Date: 11/10/2019

#>

Function Get-ClashRoyaleClanWarLog {
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
		    "Clan" = "https://api.clashroyale.com/v1/clans/%23$($ClanTag)/warlog"
	    }

	    $ClanDetails = Invoke-RestMethod -Method GET -Uri $Uri.Clan -Headers @{
		    'authorization' = "Bearer $Token"
		    'Content-Type'           = 'application/json'
	    }

	    ForEach ($ClanDetail in $ClanDetails.Items) {
		    $Clan = $ClanDetail | Select-Object -Property *
		    $ClanProperties = @{
			    seasonId     = $Clan.seasonId
			    createdDate  = $Clan.createdDate
			    participants = $Clan.participants
		    }
	        $obj = New-Object -TypeName PSObject -Property $ClanProperties
	        Write-Output $obj
        }
    }
}