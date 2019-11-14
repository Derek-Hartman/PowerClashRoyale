<#
.Synopsis
    Deleted the encrypted Token
.EXAMPLE
    Delete-ClashRoyaleToken
.NOTES
   Modified by: Derek Hartman
   Date: 11/11/2019
#>

function Delete-ClashRoyaleToken {
    Remove-ItemProperty -Path "HKCU:\Software\PowerClashRoyale" -Name "Token"    
}