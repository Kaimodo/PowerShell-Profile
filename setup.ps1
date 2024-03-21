## content of .\setup.ps1 ##
<#PSScriptInfo
.VERSION 0.8
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Setup-Script for Power-Shell Profile
#>
#Requires -RunAsAdministrator
using namespace System.Management.Automation.Host

[CmdletBinding(SupportsShouldProcess=$true)]
Param()

begin {
	$FunctionName = $MyInvocation.MyCommand.Name
	Write-Verbose "$($FunctionName): Begin."
	$TmpLocation = Get-Location
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
	#region Helper-Function
	function New-TemporaryDirectory {
        $parent = [System.IO.Path]::GetTempPath()
        [string] $name = [System.Guid]::NewGuid()
        Write-Host "Parent: $($parent)"
        Write-Host "Name: $($name)"
        return New-Item -ItemType Directory -Path (Join-Path $parent $name)
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
		if ($PSVersionTable.PSEdition -eq "Core" ) {
			Write-Host "$(Get-TimeStamp):$($FunctionName):This Script is meant to be run on Windows PowerShell Desktop $($PSVersionTable.PSEdition)" -ForegroundColor Red
		} else {
			Write-Host "$(Get-TimeStamp):$($FunctionName):PSDesktop: $($PSVersionTable.PSVersion)" -ForegroundColor Green
			$File = Get-ChildItem $PROFILE.CurrentUserCurrentHost
			$FileLocation = $File.Directoryname.ToString()
			Write-Host "$(Get-TimeStamp):$($FunctionName):FL: $($FileLocation)" -ForegroundColor Green
			if (Test-Path -Path $FileLocation) {
				Write-Host "$(Get-TimeStamp):$($FunctionName):Yes: $($FileLocation)" -ForegroundColor Green
			} else {
				Write-Host "$(Get-TimeStamp):$($FunctionName):No: $($FileLocation)" -ForegroundColor Red
				Write-Host "$(Get-TimeStamp):$($FunctionName):Creating directory $FileLocation" -ForegroundColor Blue      
				New-Item -ItemType Directory -Force -Path $FileLocation | Out-Null
			}
		
			$Tmp=New-TemporaryDirectory
			$Out="$($Tmp.FullName)\Profile.zip"
			Invoke-WebRequest 'https://github.com/Kaimodo/PowerShell-Profile/archive/refs/heads/main.zip' -OutFile $Out
			Write-Host "$(Get-TimeStamp):$($FunctionName):Tmp: $($Tmp)"
		
			Set-Location $Tmp
			Expand-Archive $Out 
			$TmpProf = Join-Path -Path $Tmp -ChildPath "Profile"
			Write-Host $TmpProf
			Set-Location $TmpProf
		
			Rename-Item .\PowerShell-Profile-main .\PowerShell-Profile
			Remove-Item .\Powershell-Profile\.vscode -Recurse -Force -Confirm:$false
			Remove-Item .\Powershell-Profile\media -Recurse -Force -Confirm:$false
			Remove-Item .\Powershell-Profile\.gitignore
			Remove-Item .\Powershell-Profile\setup.ps1
		
			Set-Location $Tmp
			Remove-Item .\Profile.zip
		
			$CopyLocation = Join-path $TmpProf "PowerShell-Profile\*"
			Write-Host "$(Get-TimeStamp):$($FunctionName):CopyLocation: $($CopyLocation)"
		
			#TODO: Check again and than change to: $FileLocation
			$DestinationPath ="D:\_dev\_workdir\.tmp\out"			
			Write-Host "$(Get-TimeStamp):$($FunctionName):DestinationPath: $($DestinationPath)"
		
			if (!(Test-Path -PathType Container -Path $DestinationPath)) {
				Write-Host "$(Get-TimeStamp):$($FunctionName):Creating directory $DestinationPath" -ForegroundColor Blue      
				New-Item -ItemType Directory -Force -Path $DestinationPath | Out-Null
			}
		
			Copy-Item -Path $CopyLocation -Destination $DestinationPath -Recurse -Force -Confirm:$false
		
		
		
			Set-Location $TmpLocation        
			$answer = $Host.UI.PromptForChoice('title', 'Delete Temporary Folder?', @('&Yes', '&No'), 1)
			if ($answer -eq 0) {
				Write-Host "$(Get-TimeStamp):$($FunctionName):Removing Folder: $($Tmp)" -ForegroundColor Green
				try {
					Remove-Item $Tmp -Recurse -Force -Confirm:$false -ErrorAction Stop
				}catch [Exception] {
					Write-Verbose "$(Get-TimeStamp):$($FunctionName):Process.catch"
					Write-Host "$(Get-TimeStamp):$($FunctionName):Error on line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
					Write-Output $_.Exception|format-list -force
				}
			}else{
				Write-Host "$(Get-TimeStamp):$($FunctionName):Folder: $($Tmp) has NOT been removed!" -ForegroundColor Red
			}
		}
		
		#TODO: Checkfrom here
		#& $profile

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
		Write-Host "$(Get-TimeStamp):$($FunctionName):Error on line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
		Write-Output $_.Exception|format-list -force
	}
}

end {
		Write-Verbose "$(Get-TimeStamp):$($FunctionName): End."
		$ErrorActionPreference = $TempErrAct
		if ($logFileFolderPath -ne "") { Stop-Transcript }
	}