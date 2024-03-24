## content of .\Load-Module.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
	Install and Import Module.
#>
function Load-Module {
	<#
	.SYNOPSIS
		Install and Import Module. 
	.DESCRIPTION
		Import the specific Module. if Its not Installed, do so and import it.
	.PARAMETER Name
		The Name of the Module
	.PARAMETER ArgumentList
		Arguments needed for the Import of the Module
	.EXAMPLE
		PS> ./Load-Module PSWindowsUpdate
	.NOTES
		Author: Kai Krutscho
	.LINK
		[1]: 	https://www.github.com/Kaimodo/PowerShell-Profile
	#>
	[CmdletBinding()]
	Param(
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$Name,
		[Parameter(Position=1, Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$ArgumentList
	)

	begin {
		$FunctionName = $MyInvocation.MyCommand.Name
		Write-Verbose "$($FunctionName): Begin."
		$TempErrAct = $ErrorActionPreference
		$ErrorActionPreference = "Stop"	
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
	}
	process {
		try {
			Write-Verbose "$(Get-TimeStamp):$($FunctionName):Process"
			# If module is imported say that and do nothing
			if (Get-Module | Where-Object {$_.Name -eq $Name}) {
				write-host "$(Get-TimeStamp):$($FunctionName): Module $Name is already imported."
			}
			else {
		
				# If module is not imported, but available on disk then import
				if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $Name}) {
					Import-Module -Name $Name -ArgumentList $ArgumentList -PassThru
				}
				else {
		
					# If module is not imported, not available on disk, but is in online gallery then install and import
					try {
					
						if (Find-Module -Name $Name | Where-Object {$_.Name -eq $Name}) {
							Install-Module -Name $Name -Force -Verbose -Scope CurrentUser
							Import-Module -Name $Name -ArgumentList $ArgumentList -PassThru
						}
						else {  
							write-host "$(Get-TimeStamp):$($FunctionName): Module $Name not imported, not available and not in online gallery, exiting."
							EXIT 1
						}
					}
					catch [Exception] {
						Write-Verbose "$(Get-TimeStamp):$($FunctionName): Process.catch"
						Write-Output $_.Exception|format-list -force
					}
					
					
				}
			}
		}
		catch [Exception] {
            Write-Verbose "$(Get-TimeStamp):$($FunctionName): Process.catch"
			Write-Host "$(Get-TimeStamp)Error on line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
            Write-Output $_.Exception|format-list -force
        }
	}
	end {
			Write-Verbose "$(Get-TimeStamp):$($FunctionName): End."
			$ErrorActionPreference = $TempErrAct
	}
}