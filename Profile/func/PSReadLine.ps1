## content of .\PSReadLine.ps1 ##
function PSReadLine {
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
			Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
			Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
			Set-PSReadLineKeyHandler -Key F7 `
                         -BriefDescription History `
                         -LongDescription 'Show command history' `
                         -ScriptBlock {
				$pattern = $null
				[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
				if ($pattern) {
					$pattern = [regex]::Escape($pattern)
				}

				$history = [System.Collections.ArrayList]@(
					$last = ''
					$lines = ''
					foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineOption).HistorySavePath)) {
						if ($line.EndsWith('`')) {
							$line = $line.Substring(0, $line.Length - 1)
							$lines = if ($lines) {
								"$lines`n$line"
							} else {
								$line
							}
							continue
						}

						if ($lines)  {
							$line = "$lines`n$line"
							$lines = ''
						}

						if (($line -cne $last) -and (!$pattern -or ($line -match $pattern))) {
							$last = $line
							$line
						}
					}
				)
				$history.Reverse()

				$command = $history | Out-GridView -Title History -PassThru
				if ($command) {
					[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
					[Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
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
