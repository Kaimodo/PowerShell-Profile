## content of .\Aliasses.ps1 ##
function Aliasses {
<#
	.SYNOPSIS
		...
	.DESCRIPTION
		...
	.PARAMETER <param>
		...
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
		

	}
	process {
		try {
			Write-Verbose "$($FunctionName):Process"
			Set-ALias -Name dir -Value Get-CHildItem -Option AllScope
			Set-ALias -Name ls -Value Get-CHildItem -Option AllScope
			Set-ALias cdirl Get-ChildItem | Format-List
			Set-Alias sudo Invoke-Elevated
			Set-Alias rm Remove-ItemSafely -Option AllScope


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
