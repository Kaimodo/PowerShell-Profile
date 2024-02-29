## content of .\Transscript.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Setup Transcription
#>
function Transscript {
<#
	.SYNOPSIS
		Setup Transcription
	.DESCRIPTION
		Setup and run Transcription
	.EXAMPLE
		PS> ./Transscript.ps1
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
			if(!(Test-Path variable:doc)){
				New-Variable    -Name doc -Value "$home\documents" `
								-Description "My documents library. Profile created" `
								-Option ReadOnly -Scope "Global"
			}
			if(!(Test-Path variable:backupHome)){
				New-Variable    -name backupHome -value "$doc\WindowsPowerShell\profileBackup" `
								-Description "Folder for profile backups. Profile created" `
								-Option ReadOnly -Scope "Global"
			}

			Function Replace-InvalidFileCharacters {
				Param ($stringIn,
						$replacementChar)
				# Replace-InvalidFileCharacters "my?string"
				# Replace-InvalidFileCharacters (get-date).tostring()
				$stringIN -replace "[$( [System.IO.Path]::GetInvalidFileNameChars() )]", $replacementChar
			}

			Function Test-ConsoleHost {
				Write-Verbose "$($FunctionName):Process: Test-ConsoleHost"
				if(($host.Name -match 'consolehost')) {$true}
				Else {$false}  
			}

			Function Get-TranscriptName {
				$date = Get-Date -format s
					"{0}.{1}.{2}.txt" -f "PowerShell_Transcript", $env:COMPUTERNAME,
					(rifc -stringIn $date.ToString() -replacementChar "-") 
			}

			Set-Alias -Name rifc -Value Replace-InvalidFileCharacters | out-null
			Set-Alias -Name tch -Value Test-ConsoleHost | out-null

			If(tch) {Start-Transcript -Path (Join-Path -Path `
				$doc -ChildPath $(Get-TranscriptName))}

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

<#
catch{
			Write-Verbose "$($FunctionName): Process.catch"
			"Stuff Failed" | Write-Error

			$ExceptionLevel   = 0
			$BagroundColorErr = 'DarkGreen'
			$e                = $_.Exception
			$Msg              = "[$($ExceptionLevel)] {$($e.Source)} $($e.Message)"
			$Msg.PadLeft($Msg.Length + (2*$ExceptionLevel)) | Write-Host -ForegroundColor White -BackgroundColor $BagroundColorErr
			$Msg.PadLeft($Msg.Length + (2*$ExceptionLevel)) | Write-Output

			while($e.InnerException)
			{
				$ExceptionLevel++
				if($ExceptionLevel % 2 -eq 0)
				{
					$BagroundColorErr = 'Darkblue'
				}
				else
				{
					$BagroundColorErr='Black'
				}

				$e = $e.InnerException

				$Msg = "[$($ExceptionLevel)] {$($e.Source)} $($e.Message)"
				$Msg.PadLeft($Msg.Length + (2*$ExceptionLevel)) | Write-Host -ForegroundColor White -BackgroundColor $BagroundColorErr
				$Msg.PadLeft($Msg.Length + (2*$ExceptionLevel)) | Write-Output
			}
		}#>