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
#$SampleMode = $true
#endregion

#TODO: ScriptRoot anpassen
#region Dot-Source relevant Functions

Write-Host "Loading Functions..." -ForegroundColor blue
$Path = $PSScriptRoot +"/Profile/func/"
Get-ChildItem -Path $Path -Filter *.ps1 |ForEach-Object {
    Write-Host "Function: $($_.Name)" -ForegroundColor blue
	. $_.FullName
}
#endregion




#region Modules
<#
$Sample = (Get-Content ($PSScriptRoot + "./Profile/modules.json.sample") -Raw) | ConvertFrom-Json 
$Personal = (Get-Content ($PSScriptRoot + "./Profile/modules.json") -Raw) | ConvertFrom-Json 

$Basic | Select-Object -Property NAME | ForEach-Object {
	Write-Verbose "Loading ModuleB: $($_.NAME)"
	$name = $_.NAME 
	Load-Module $name
}
$Extended | Select-Object -Property NAME | ForEach-Object {
	Write-Verbose "Loading ModuleE: $($_.NAME)"
	$name = $_.NAME 
	Load-Module $name
}
if (TimedPrompt "Load TimedSample?" 3) {
	Write-Host "Loading TimedSample... " -ForegroundColor blue
	$Timed1 | Select-Object -Property NAME,HTTP | ForEach-Object {
		Write-Verbose "Loading ModuleT: $($_.NAME)"
		$name = $_.NAME 
		Load-Module $name
	}
}
#>
$answer = $Host.UI.PromptForChoice('Update Modules', 'Search for Updates to your Modules?', @('&Yes', '&No'), 1)
		if ($answer -eq 0) {
			#yes
			Write-Host 'YES' -ForegroundColor green
			Update-Modules
		}else{
			#no
			Write-Host 'NO' -ForegroundColor green
		}
#endregion 


#region start Profile
Write-Host "PS7 Profile geladen" -ForegroundColor Blue
#[bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")


Aliasses
PSReadLine
Write-StartScreen
Mini-Functions
Transscript

Init

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
