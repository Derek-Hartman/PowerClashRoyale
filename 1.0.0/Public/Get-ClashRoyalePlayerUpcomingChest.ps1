<#
.Synopsis
    list Players Details from Clash Royale

.EXAMPLE
    Get-ClashRoyalePlayerUpcomingChest -PlayerTag "QPPJUGU0"

.EXAMPLE
    Get-ClashRoyalePlayerUpcomingChest -Token "YourToken" -PlayerTag "QPPJUGU0"

.NOTES
   Modified by: Derek Hartman
   Date: 11/10/2019

#>

Function Get-ClashRoyalePlayerUpcomingChest {
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
		    "Player" = "https://api.clashroyale.com/v1/players/%23$($PlayerTag)/upcomingchests"
	    }

	    $PlayersChests = Invoke-RestMethod -Method GET -Uri $Uri.Player -Headers @{
		    'authorization' = "Bearer $Token"
		    'Content-Type'           = 'application/json'
	    }

	    ForEach ($PlayersChest in $PlayersChests.items) {
		    $Player = $PlayersChest | Select-Object -Property *
		    $PlayerProperties = @{
			    index = $Player.index
			    name  = $Player.name
		    }
	        $obj = New-Object -TypeName PSObject -Property $PlayerProperties
	        Write-Output $obj
        }
    }
}