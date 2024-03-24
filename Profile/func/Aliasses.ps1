## content of .\Aliasses.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Set common Aliasses
#>
function Aliasses {
<#
	.SYNOPSIS
		Set's Common aliasses
	.DESCRIPTION
		Set's Common aliasses for easier use
	.EXAMPLE
		PS> ./Aliasses.ps1
	.NOTES
		Author: Kai Krutscho
	.LINK
		[1]: 	https://www.github.com/Kaimodo/PowerShell-Profile
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
			Write-Host "Error on line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
            Write-Output $_.Exception|format-list -force
        }
	}
	end {
			Write-Verbose "$($FunctionName): End."
			$ErrorActionPreference = $TempErrAct
	}
}
