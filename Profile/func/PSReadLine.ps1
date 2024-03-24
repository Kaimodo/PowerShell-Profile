## content of .\PSReadLine.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
	PSReadLine
#>
function PSReadLine {
<#
	.SYNOPSIS
		Setup PSReadLine
	.DESCRIPTION
		Setup PSReadLine
	.EXAMPLE
		PS> ./PSReadLine.ps1
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
			Write-Verbose "$(Get-TimeStamp):$($FunctionName): Process"
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
            Write-Verbose "$(Get-TimeStamp):$($FunctionName): Process.catch"
			Write-Host "$(Get-TimeStamp):$($FunctionName): Error on line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
            Write-Output $_.Exception|format-list -force
        }
	}
	end {
			Write-Verbose "$(Get-TimeStamp):$($FunctionName): End."
			$ErrorActionPreference = $TempErrAct
	}
}
