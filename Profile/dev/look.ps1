## content of .\test.ps1 ##
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

function test {
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
		#TODO: Change Prefix
		[string]$logFilePrefix = "init"
		[string]$logFileDateFormat = "yyyyMMdd_HHmmss"
		[int]$logFileRetentionDays = 30
		$EnvPath = Split-Path $PSScriptRoot -Parent		
		$Environment = (Get-Content ($EnvPath + "/environment.json") -Raw) | ConvertFrom-Json 
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
			Write-Output "$(Get-TimeStamp):$($FunctionName): Example output message. Check out the timestamp on this bad boy."
			#TODO: Start Here:

            $PathToTest = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
            $P = $pathTotest.ToString() + "\Profile\Log"
            New-Item -Path $P -ItemType File -Name "TESTLogInit.log" -Value "test"

		}
		catch [Exception] {
			Write-Verbose "$(Get-TimeStamp):$($FunctionName): Process.catch"
			Write-Host "$(Get-TimeStamp):$($FunctionName): Error on line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
			Write-Output $_.Exception|format-list -force
		}
	}

	end {
			Write-Verbose "$(Get-TimeStamp):$($FunctionName): End."
			$ErrorActionPreference = $TempErrAct
			if ($logFileFolderPath -ne "") { Stop-Transcript }
		}
}
