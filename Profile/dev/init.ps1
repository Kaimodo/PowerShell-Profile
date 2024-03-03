## content of .\init.ps1 ##
<#PSScriptInfo
.VERSION 0.4
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Default Script Template
#>
<#
Requires
     -Version 5
#>

using namespace System.Management.Automation.Host
#https://www.sharepointdiary.com/2021/11/progress-bar-in-powershell.html

function Init {
	<#
	.SYNOPSIS
		
	.DESCRIPTION
		
	.PARAMETER Prompt
		
	.PARAMETER Time
		
	.EXAMPLE
		PS> ./
	.NOTES
		Author: Kai Krutscho
	.LINK
		https://www.github.com/Kaimodo/PowerShell-Profile
	#>
		
	[CmdletBinding()]
	Param()

	begin {
		$FunctionName = $MyInvocation.MyCommand.Name
		Write-Verbose "$($FunctionName): Begin."
		$TempErrAct = $ErrorActionPreference
		$ErrorActionPreference = "Stop"
		
        #region initialization
        [string]$logFileFolderPath = $PSScriptRoot + "./Profile/log"
		#TODO: Change Prefix
		[string]$logFilePrefix = "init_"
		[string]$logFileDateFormat = "yyyyMMdd_HHmmss"
		[int]$logFileRetentionDays = 30

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

		if ($logFileFolderPath -ne "")
		{
			if (!(Test-Path -PathType Container -Path $logFileFolderPath)) {
				Write-Output "$(Get-TimeStamp) Creating directory $logFileFolderPath" | Out-Null
				New-Item -ItemType Directory -Force -Path $logFileFolderPath | Out-Null
			} else {
				$DatetoDelete = $(Get-Date).AddDays(-$logFileRetentionDays)
				Get-ChildItem $logFileFolderPath | Where-Object { $_.Name -like "*$logFilePrefix*" -and $_.LastWriteTime -lt $DatetoDelete } | Remove-Item | Out-Null
			}
			
			$logFilePath = $logFileFolderPath + "\$logFilePrefix" + (Get-Date -Format $logFileDateFormat) + ".LOG"

			# attempt to start the transcript log, but don't fail the script if unsuccessful:
			try 
			{
				Start-Transcript -Path $logFilePath -Append
			}
			catch [Exception]
			{
				Write-Warning "$(Get-TimeStamp) Unable to start Transcript: $($_.Exception.Message)"
				$logFileFolderPath = ""
			}
		}
		#endregion initialization
		
	}
	process {
		try {
			Write-Verbose "$($FunctionName):Process"
			Write-Output "$(Get-TimeStamp) Example output message. Check out the timestamp on this bad boy."
			#TODO: Start Here:
				
			#Snipet
			$answer = $Host.UI.PromptForChoice('title', 'question', @('&Yes', '&No'), 1)
			if ($answer -eq 0) {
				#yes
				Write-Host 'YES'
			}else{
				#no
				Write-Host 'NO'
			}
		}
		catch [Exception] {
			Write-Verbose "$($FunctionName): Process.catch"
			Write-Host "Error on line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
			Write-Output $_.Exception|format-list -force
		}
	}

	end {
			Write-Verbose "$($FunctionName): End."
			$ErrorActionPreference = $TempErrAct
			if ($logFileFolderPath -ne "") { Stop-Transcript }
		}
}