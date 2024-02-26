## content of .\TimedPrompt.ps1 ##
function TimedPrompt {
<#
	.SYNOPSIS
		ASk for input and wait for a certain amount of time.
	.DESCRIPTION
		ASk for input and wait for a certain amount of time. This is useful when you want to wait for a certain amount of time and then continue.
	.PARAMETER Prompt
		The Prompt to display.
	.PARAMETER Time
		The Time to wait.
	.EXAMPLE
		PS> ./TimedPrompt -Prompt "Are you ready?" -Time 10
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
		$FunctionName = $MyInvocation.MyCommand.Name
		Write-Verbose "$($FunctionName): Begin."
		$TempErrAct = $ErrorActionPreference
		$ErrorActionPreference = "Stop"
		

	}
	process {
		try {
			Write-Verbose "$($FunctionName):Process"
			Write-Host -NoNewline $Prompt
			$secondsCounter = 0
			$subCounter = 0
			While ( (!$host.ui.rawui.KeyAvailable) -and ($count -lt $Time) ){
				start-sleep -m 10
				$subCounter = $subCounter + 10
				if($subCounter -eq 1000)
				{
					$secondsCounter++
					$subCounter = 0
					Write-Host -NoNewline "."
				}       
				If ($secondsCounter -eq $Time) { 
					Write-Host "`r`n"
					return $false;
				}
			}
			Write-Host "`r`n"
			return $true;
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