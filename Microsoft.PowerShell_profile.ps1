## content of .\_profile.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
	Profile Script
#>

using namespace System.Management.Automation.Host

[CmdletBinding()]
Param()

#region SWITCH for Sample-Mode
#TODO: Change $SampleMode to False after you added All your own Modules to the JSON-File
$SampleMode = $true
#endregion

#region Helper-Function
function Get-TimeStamp {
	Param(
	[switch]$NoWrap,
	[switch]$Utc
	)
	$dt = Get-Date
	if ($Utc -eq $true) {
		$dt = $dt.ToUniversalTime()
	}
	$str = "{0:MM/dd/yy} {0:HH:mm:ss}" -f $dt

	if ($NoWrap -ne $true) {
		$str = "[$str]"
	}
	return $str
}
#endregion

#TODO: ScriptRoot anpassen
#region Dot-Source relevant Functions

Write-Host "$(Get-TimeStamp)[PROFILE] Loading Functions "-ForegroundColor blue
$Path = $PSScriptRoot +"/Profile/func/"
Get-ChildItem -Path $Path -Filter *.ps1 |ForEach-Object {
    Write-Host "$(Get-TimeStamp)[PROFILE] Function: $($_.Name)" -ForegroundColor Green
	. $_.FullName
}
#endregion

#region Transscript
Transscript
#endregion

#region Modules
$answer = $Host.UI.PromptForChoice('Update Modules', 'Search for Updates to your Modules?', @('&Yes', '&No'), 1)
		if ($answer -eq 0) {
			#yes
			Write-Host 'YES' -ForegroundColor green
			Update-Modules
		}else{
			#no
			Write-Host 'NO' -ForegroundColor green
		}

$ModulePath = $PSScriptRoot + "\Profile\"
Write-Verbose "$(Get-TimeStamp)[PROFILE]Path to Modules.json: $($ModulePath)"
$Modules = (Get-Content ($ModulePath + "module.json") -Raw) | ConvertFrom-Json
			
if ($SampleMode) {
	Write-Host "$(Get-TimeStamp)[PROFILE]Samples" -ForegroundColor red
	foreach ($Mod in $Modules.Samples.Normal.Modules) {
		$Mod | Select-Object -Property Name | ForEach-Object {
			Load-Module $_.Name
		}
	}
		
	$Extended = $Host.UI.PromptForChoice('Extended Modules', 'Install Extended Modules?', @('&Yes', '&No'), 1)
	if ($Extended -eq 0) {
		#yes
		Write-Host 'YES' -ForegroundColor green
		foreach ($Mod in $Modules.Samples.Extended.Modules) {      
			$Mod | Select-Object -Property Name | ForEach-Object {
				Load-Module $_.Name
			}
		}
	}else{
		#no
		Write-Host 'NO' -ForegroundColor red
	}
}

#endregion 


#region start Profile
Write-Host "$(Get-TimeStamp)[PROFILE]PS7 Profile geladen" -ForegroundColor Green

Aliasses
PSReadLine
Write-StartScreen
Mini-Functions

oh-my-posh --init --shell pwsh --config "./Profile/ohmyposhv3-v2.json" | Invoke-Expression

#endregion 

#region Chocolatey
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
#endregion

Remove-item alias:cls
