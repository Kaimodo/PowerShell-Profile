## content of .\Update-Modules.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
	Checks for all currently installed Powershell modules whether they're outdated.
	Optionally allows you to update the outdated modules as well.
	Some modules may require Administrator permissions to update.

.LINK
	original script by Jeff Hill:
	https://sqladm.in/posts/check-if-you-have-old-versions-of-modules/
#>
function Update-Modules {
	
	[CmdletBinding()]
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

		[string]$logFilePrefix = "Update-Modules_"
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
			#TODO: Start Here:
			Write-Progress -Activity "Checking Modules..." -CurrentOperation "Retrieving modules list..." -PercentComplete 0
			# Get all the modules that are installed.
			$Modules = Get-InstalledModule
			# Create an empty array to store our results in.
			$modcheck = @();
			$i = 0;
			# Loop through all the modules.
			foreach($mod in $Modules){
				$i = $i + 1;
				Write-Progress -Activity "Checking Modules..." -CurrentOperation $mod.Name -PercentComplete ($i * 100 / $Modules.Count)
				# get the information for the latest from PSGallery.
				$PSGalleryMod = Find-Module $mod.Name;
				# Compare the installed version to the PSGallery version.
				if($PSGalleryMod.Version -ne $mod.version){
					# if they're different, put the details in a PSCustomObject.
					$modversions = [pscustomobject]@{
						Name = $($mod.name)
						InstalledVersion = $($mod.Version);InstalledPubDate =  $($mod.PublishedDate.tostring('MM/dd/yy'))
						AvailableVersion =  $($PSGalleryMod.Version)
						NewPubDate =  $($PSGalleryMod.PublishedDate.tostring('MM/dd/yy'))
					}
				# add the object to the array.
				$modcheck += $modversions;
				}
			}

			Write-Progress -Activity "Checking Modules..." -CurrentOperation $mod.Name -Completed

			$modcheck | Format-Table

			if ($modcheck.Count -eq 0) {
				Write-Host "No outdated modules found"
			} else {
				$doUpdate = Read-Host -Prompt "Do you want to update all $($modcheck.Count) outdated module(s) now? (Y/N)"

				if ($doUpdate.ToUpper().StartsWith("Y"))
				{
					$i = 0;
					$modcheck | ForEach-Object {
						$i = $i + 1;
						Write-Progress -Activity "Updating Modules..." -CurrentOperation $_.Name -PercentComplete ($i * 100 / $modcheck.Count)
						Update-Module $_.Name
					}
				
					Write-Progress -Activity "Updating Modules..." -CurrentOperation $_.Name -Completed
				}
			}
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
}