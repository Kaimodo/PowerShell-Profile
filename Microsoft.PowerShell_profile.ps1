## content of .\_profile.ps1 ##
<#PSScriptInfo
.VERSION 0.1
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
	Profile Script
#>
[CmdletBinding(SupportsShouldProcess=$true)]
Param()


#region Dot-Source relevant Functions
$Path = $PSScriptRoot +"/Profile/func/"
Get-ChildItem -Path $Path -Filter *.ps1 |ForEach-Object {
    . $_.FullName
}
#endregion




#region Load Modules
$Basic = (Get-Content ($PSScriptRoot + "./Profile/modulesBasic.json") -Raw) | ConvertFrom-Json 
$Extended = (Get-Content ($PSScriptRoot + "./Profile/modulesExtended.json") -Raw) | ConvertFrom-Json
$Timed1 = (Get-Content ($PSScriptRoot + "./Profile/modulesTimed1.json") -Raw) | ConvertFrom-Json

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
#endregion 


#region start Profile
Write-Host "PS7 Profile geladen" -ForegroundColor Blue
#[bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

Basics
Aliasses
PSReadLine
Write-StartScreen
Transscript

oh-my-posh --init --shell pwsh --config "./Profile/ohmyposhv3-v2.json" | Invoke-Expression

#endregion 

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
Remove-item alias:cls
