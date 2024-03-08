## content of .\%%FUNCTIONNAME%%.ps1 ##
<#PSScriptInfo
.VERSION %%VERSION%%
.AUTHOR %%AUTHOR%%
.PROJECTURI %%PROJECTURI%%
.DESCRIPTION
    Default Script Template
#>
<#
Requires
     -Version <N>[.<n>]
          <Specifies the minimum version of Windows PowerShell that the script requires. Enter a major version number and optional minor version number.>
     -PSSnapin <PSSnapin-Name> [-Version <N>[.<n>]]
          <Specifies a Windows PowerShell snap-in that the script requires. Enter the snap-in name and an optional version number.>
     -Modules { <Module-Name> | <Hashtable> }
          <Specifies Windows PowerShell modules that the script requires. Enter the module name and an optional version number. The Modules parameter is introduced in Windows PowerShell 3.0.+
          If the required modules are not in the current session, Windows PowerShell imports them. If the modules cannot be imported, Windows PowerShell throws a terminating error.
          For each module, type the module name () or a hash table with the following keys. The value can be a combination of strings and hash tables.>
               ModuleName. This key is required.
               ModuleVersion. This key is required.
               GUID. This key is optional.
     -ShellId <ShellId>
          <Specifies the shell that the script requires. Enter the shell ID.>
     -RunAsAdministrator
          <When this switch parameter is added to your requires statement, it specifies that the Windows PowerShell session in which you are running the script must be started with elevated user rights (Run as Administrator). This switch was introduced in PowerShell 4.>
#>

using namespace System.Management.Automation.Host
#https://www.sharepointdiary.com/2021/11/progress-bar-in-powershell.html

function %%FUNCTIONNAME%% {
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
	Param(

		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$Prompt,

		[Parameter(Position=1, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.Int32]
		$Time
	)

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
		[string]$logFilePrefix = "%%FUNCTIONNAME%%"
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