## content of .\_profile.ps1 ##
<#PSScriptInfo
.VERSION 0.7
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
	Profile Script
#>

using namespace System.Management.Automation.Host

[CmdletBinding()]
Param()

#region Gloabls
$global:ProfileRoot =$PSScriptRoot
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
#region Lock-File
$LockFile = Join-Path $PSScriptRoot "Profile.lock"
# Check if the lock file exists
if (Test-Path $LockFile) {
    Write-Host "$(Get-TimeStamp)[PROFILE] Another instance is already running, aborting" -ForegroundColor Red
    exit 0
}

# Create the lock file
New-Item -ItemType File -Path $LockFile | Out-Null
#endregion

#region Load Environment.json
$EnvPath = $ProfileRoot	+"\Profile"
$Environment = (Get-Content ($EnvPath + "\environment.json") -Raw) | ConvertFrom-Json
#endregion

#region Check for Updates
#TODO: Code for Auto Update

#endregion

#region Dot-Source relevant Functions
Write-Host "$(Get-TimeStamp)[PROFILE] Loading Functions "-ForegroundColor blue
$Path = $ProfileRoot +"/Profile/func/"
Get-ChildItem -Path $Path -Filter *.ps1 |ForEach-Object {
    Write-Host "$(Get-TimeStamp)[PROFILE] Function: $($_.Name)" -ForegroundColor Blue
	. $_.FullName
}
#Get-ChildItem -Path $Path -Filter *.ps1 | ForEach-Object {
#    Write-Host "$(Get-TimeStamp)[PROFILE] Function: $($_.Name)" -ForegroundColor Blue
#    Invoke-Expression (Get-Content $_.FullName -Raw)
#}
#Get-ChildItem -Path $Path -Filter *.ps1 |ForEach-Object -process {Invoke-Expression ". $_"}
#endregion

#region Transscript
Transscript
#endregion

#region Modules
$PowerTabConfig = $EnvPath + "\PowerTabConfig.xml"
$answer = $Host.UI.PromptForChoice('Update Modules', 'Search for Updates to your Modules?', @('&Yes', '&No'), 1)
		if ($answer -eq 0) {
			#yes
			Write-Host "$(Get-TimeStamp)[PROFILE] Searching for Module-Updates" -ForegroundColor Green
			Update-Modules
		}else{
			#no
			Write-Host "$(Get-TimeStamp)[PROFILE] Skipped Module-Update check" -ForegroundColor red
		}

$ModulePath = $ProfileRoot + "\Profile\"
Write-Verbose "$(Get-TimeStamp)[PROFILE] Path to Modules.json: $($ModulePath)"

$PSVersion=$PSVersionTable.PSVersion
[string]$PSV=$PSVersion.toString()
			
if ($Environment.Variables.SampleMode -eq $true) {
	$Modules = (Get-Content ($ModulePath + "module.json.sample") -Raw) | ConvertFrom-Json
	Write-Host "$(Get-TimeStamp)[PROFILE] Samples" -ForegroundColor red
	Write-Host "$(Get-TimeStamp)[PROFILE] Change SampleMode to false in '/Profile/environment.json' when you are done with testing" -ForegroundColor red
	foreach ($Mod in $Modules.MyModules.Normal.Modules) {
		$Mod | Select-Object -Property * | ForEach-Object {
			if ($_.Version -lt $PSV) {				
				if ($_.Name -ne "PowerTab") {
					Load-Module $_.Name
				} else {
					Load-Module $_.Name $PowerTabConfig
				}
			} else {
				Write-Host "$(Get-TimeStamp)[PROFILE] Module: $($_.Name).$($_.Version) is not Supported by your Powershell Version: $($PSV)" -ForegroundColor Red
			}
		}
	}
		
	$Extended = $Host.UI.PromptForChoice('Extended Modules', 'Install Extended Modules?', @('&Yes', '&No'), 1)
	if ($Extended -eq 0) {
		#yes
		Write-Host "$(Get-TimeStamp)[PROFILE] ExtendedModules" -ForegroundColor Green
		foreach ($Mod in $Modules.MyModules.Extended.Modules) {      
			$Mod | Select-Object -Property * | ForEach-Object {
				if ($_.Version -lt $PSV) {					
					if ($_.Name -ne "PowerTab") {
						Load-Module $_.Name
					}
				} else {
					Write-Host "$(Get-TimeStamp)[PROFILE] Module: $($_.Name).$($_.Version) is not Supported by your Powershell Version: $($PSV)" -ForegroundColor Red
				}
			}
		}
	}else{
		#no
		Write-Host "$(Get-TimeStamp)[PROFILE] Extended Modules not loaded" -ForegroundColor red
	}
} else {
	$Modules = (Get-Content ($ModulePath + "module.json") -Raw) | ConvertFrom-Json
	Write-Host "$(Get-TimeStamp)[PROFILE] MyModules" -ForegroundColor Green
	foreach ($Mod in $Modules.MyModules.Normal.Modules) {
		$Mod | Select-Object -Property * | ForEach-Object {
			if ($_.Version -lt $PSV) {
				if ($_.Name -ne "PowerTab") {
					Load-Module $_.Name
				} else {
					Load-Module $_.Name $PowerTabConfig
				}
			} else {
				Write-Host "$(Get-TimeStamp)[PROFILE] Module: $($_.Name).$($_.Version) is not Supported by your Powershell Version: $($PSV)" -ForegroundColor Red
			}
		}
	}
		
	$Extended = $Host.UI.PromptForChoice('Extended Modules', 'Install Extended Modules?', @('&Yes', '&No'), 1)
	if ($Extended -eq 0) {
		#yes
		Write-Host "$(Get-TimeStamp)[PROFILE] ExtendedModules" -ForegroundColor Green
		foreach ($Mod in $Modules.MyModules.Extended.Modules) {      
			$Mod | Select-Object -Property * | ForEach-Object {
				if ($_.Version -lt $PSV) {
					if ($_.Name -ne "PowerTab") {
						Load-Module $_.Name
					}
				} else {
					Write-Host "$(Get-TimeStamp)[PROFILE] Module: $($_.Name).$($_.Version) is not Supported by your Powershell Version: $($PSV)" -ForegroundColor Red
				}
			}
		}
	}else{
		#no
		Write-Host "$(Get-TimeStamp)[PROFILE] Extended Modules not loaded" -ForegroundColor red
	}
}
#endregion 


#region start Profile
#Write-Host "$(Get-TimeStamp)[PROFILE]PS7 Profile geladen" -ForegroundColor Green
Write-Host "$(Get-TimeStamp)[PROFILE] Initializing Profile" -ForegroundColor Blue
PSReadLine
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
Write-StartScreen
#region Remove the lock file when the script finishes
Remove-Item $LockFile -Force
#endregion
