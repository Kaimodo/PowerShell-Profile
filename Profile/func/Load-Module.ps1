## content of .\Load-Module.ps1 ##
function Load-Module {
	<#
	.SYNOPSIS
		Install and Import Module. 
	.DESCRIPTION
		Import the specific Module. if Its not Installed, do so and import it.
	.PARAMETER Module
		The Name of the Module
	.EXAMPLE
		PS> ./Load-Module PSWindowsUpdate
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
		$Module
	)

	begin {
		$FunctionName = $MyInvocation.MyCommand.Name
		Write-Verbose "$($FunctionName): Begin."
		$TempErrAct = $ErrorActionPreference
		$ErrorActionPreference = "Stop"				
	}
	process {
		try {
			Write-Verbose "$($FunctionName):Process"
			# If module is imported say that and do nothing
			# If module is imported say that and do nothing
			if (Get-Module | Where-Object {$_.Name -eq $Module}) {
				write-host "Module $Module is already imported."
			}
			else {
		
				# If module is not imported, but available on disk then import
				if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $Module}) {
					Import-Module $Module -PassThru
				}
				else {
		
					# If module is not imported, not available on disk, but is in online gallery then install and import
					try {
					
						if (Find-Module -Name $Module | Where-Object {$_.Name -eq $Module}) {
							Install-Module -Name $Module -Force -Verbose -Scope CurrentUser
							Import-Module $Module -PassThru
						}
						else {  
							write-host "Module $Module not imported, not available and not in online gallery, exiting."
							EXIT 1
						}
					}
					catch [Exception] {
						Write-Verbose "$($FunctionName): Process.catch"
						Write-Output $_.Exception|format-list -force
					}
					
					
				}
			}
		}
		catch [Exception] {
            Write-Verbose "$($FunctionName): Process.catch"
            Write-Output $_.Exception|format-list -force
        }
	}
	end {
			Write-Verbose "$($FunctionName): End."
			$ErrorActionPreference = $TempErrAct
	}
}