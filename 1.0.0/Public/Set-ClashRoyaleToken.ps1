<#
.Synopsis
    Sets the API key for the current user in registry

.EXAMPLE
    Set-ClashRoyaleToken -Token "Token"

.NOTES
   Modified by: Derek Hartman
   Date: 11/10/2019

#>

function Set-ClashRoyaleToken {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Token,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$RegistryKeyPath = "HKCU:\Software\PowerClashRoyale"
	)

	function encrypt([string]$TextToEncrypt) {
		$secure = ConvertTo-SecureString $TextToEncrypt -AsPlainText -Force
		$encrypted = $secure | ConvertFrom-SecureString
		return $encrypted
	}
		
	if (-not (Test-Path -Path $RegistryKeyPath)) {
		New-Item -Path ($RegistryKeyPath | Split-Path -Parent) -Name ($RegistryKeyPath | Split-Path -Leaf) | Out-Null
	}
	
	$values = 'Token'
	foreach ($val in $values) {
		if ((Get-Item $RegistryKeyPath).GetValue($val)) {
			Write-Verbose "'$RegistryKeyPath\$val' already exists. Skipping."
		} else {
			Write-Verbose "Creating $RegistryKeyPath\$val"
			New-ItemProperty $RegistryKeyPath -Name $val -Value $(encrypt $((Get-Variable $val).Value)) -Force | Out-Null
		}
	}
}