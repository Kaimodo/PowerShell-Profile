## content of .\setup.ps1 ##
<#PSScriptInfo
.VERSION 0.7
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Setup-Script for Power-Shell Profile
#>
#TODO: - Write whole Setup Script
#Requires -RunAsAdministrator
using namespace System.Management.Automation.Host

[CmdletBinding(SupportsShouldProcess=$true)]
Param()

begin {
	$FunctionName = $MyInvocation.MyCommand.Name
		Write-Verbose "$($FunctionName): Begin."
		$TempErrAct = $ErrorActionPreference
		$ErrorActionPreference = "Stop"

		#region TimeStamp
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

		#region Environment
		$FunctionName = $MyInvocation.MyCommand.Name
		Write-Verbose "$(Get-TimeStamp):$($FunctionName): Begin."

		[string]$logFilePrefix = "Setup_"
		[string]$logFileDateFormat = "yyyyMMdd_HHmmss"
		[int]$logFileRetentionDays = 30
		
		$EnvPath = $ProfileRoot	+"\Profile"
		$Environment = (Get-Content ($EnvPath + "\environment.json") -Raw) | ConvertFrom-Json 
		if($Environment.Variables.Logging -eq $true){	
			[string]$logFileFolderPath = $EnvPath + $Environment.Variables.LogPath.ToString()
		} else {
			$logFileFolderPath = ""
		}
		$TempErrAct = $ErrorActionPreference	
		$ErrorActionPreference = $Environment.Variables.ErrorActionPreference.ToString()
		Write-Host "$(Get-TimeStamp):$($FunctionName):ErrorActionPreference: $ErrorActionPreference" -ForegroundColor Blue	
		#endregion

        #region initialization
		
		if ($logFileFolderPath -ne "")
		{
			if (!(Test-Path -PathType Container -Path $logFileFolderPath)) {
				Write-Output "$(Get-TimeStamp):$($FunctionName): Creating directory $logFileFolderPath"			
				New-Item -ItemType Directory -Force -Path $logFileFolderPath | Out-Null
			} else {
				$DatetoDelete = $(Get-Date).AddDays(-$logFileRetentionDays)
				Get-ChildItem $logFileFolderPath | Where-Object { $_.Name -like "*$logFilePrefix*" -and $_.LastWriteTime -lt $DatetoDelete } | Remove-Item | Out-Null
			}
			
			$logFilePath = $logFileFolderPath + "\$logFilePrefix" + "-" + (Get-Date -Format $logFileDateFormat) + ".LOG"

			# attempt to start the transcript log, but don't fail the script if unsuccessful:
			try 
			{
				Start-Transcript -Path $logFilePath -Append
			}
			catch [Exception]
			{
				Write-Warning "$(Get-TimeStamp):$($FunctionName): Unable to start Transcript: $($_.Exception.Message)"
				$logFileFolderPath = ""
			}
		}
		#endregion initialization
}
process {
	try {
		Write-Verbose "$(Get-TimeStamp):$($FunctionName):Process"
		#TODO: Actual Installation. With Folders
		#https://stackoverflow.com/questions/66428571/powershell-to-download-zip-file-from-github-api
		#https://blog.ironmansoftware.com/daily-powershell/powershell-download-github/
		#https://github.com/jayharris/dotfiles-windows
		#https://gist.github.com/chrisbrownie/f20cb4508975fb7fb5da145d3d38024a

		# OMP Install
		#
		winget install -e --accept-source-agreements --accept-package-agreements JanDeDobbeleer.OhMyPosh
		winget install -e --accept-source-agreements --accept-package-agreements SomePythonThings.WingetUIStore

		# Font Install
		# Get all installed font families
		[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
		$fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families

		# Check if CaskaydiaCove NF is installed
		if ($fontFamilies -notcontains "CaskaydiaCove NF") {
			
			# Download and install CaskaydiaCove NF
			$webClient = New-Object System.Net.WebClient
			$webClient.DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip", ".\CascadiaCode.zip")

			Expand-Archive -Path ".\CascadiaCode.zip" -DestinationPath ".\CascadiaCode" -Force
			$destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
			Get-ChildItem -Path ".\CascadiaCode" -Recurse -Filter "*.ttf" | ForEach-Object {
				If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {        
					# Install font
					$destination.CopyHere($_.FullName, 0x10)
				}
			}

			# Clean up
			Remove-Item -Path ".\CascadiaCode" -Recurse -Force
			Remove-Item -Path ".\CascadiaCode.zip" -Force
		}

		# Choco install
		#
		Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


	}
	catch [Exception] {
		Write-Verbose "$(Get-TimeStamp):$($FunctionName): Process.catch"
		Write-Host "Error on line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
		Write-Output $_.Exception|format-list -force
	}
}

end {
		Write-Verbose "$($FunctionName): End."
		$ErrorActionPreference = $TempErrAct
		if ($logFileFolderPath -ne "") { Stop-Transcript }
	}