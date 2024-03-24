## content of .\cls.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Alien-CLS
#>
function global:clsa {
<#
	.SYNOPSIS
		Fancy cls
	.DESCRIPTION
		Well... It's an Alien...
	.EXAMPLE
		PS> ./cls.ps1
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
			Clear-Host
			Write-Host $block -ForegroundColor Green
			$block = @"

.     .       .  .   . .   .   . .    +  .
	.     .  :     .    .. :. .___---------___.
		.  .   .    .  :.:. _".^ .^ ^.  '.. :"-_. .
	.  :       .  .  .:../:            . .^  :.:\.
		.   . :: +. :.:/: .   .    .        . . .:\
	.  :    .     . _ :::/:               .  ^ .  . .:\
	.. . .   . - : :.:./.                        .  .:\
	.      .     . :..|:                    .  .  ^. .:|
	.       . : : ..||        .                . . !:|
	.     . . . ::. ::\(                           . :)/
	.   .     : . : .:.|. ######              .#######::|
	:.. .  :-  : .:  ::|.#######           ..########:|
	.  .  .  ..  .  .. :\ ########          :######## :/
	.        .+ :: : -.:\ ########       . ########.:/
	.  .+   . . . . :.:\. #######       #######..:/
		:: . . . . ::.:..:.\           .   .   ..:/
	.   .   .  .. :  -::::.\.       | |     . .:/
		.  :  .  .  .-:.":.::.\             ..:/
	.      -.   . . . .: .:::.:.\.           .:/
.   .   .  :      : ....::_:..:\   ___.  :/
	.   .  .   .:. .. .  .: :.:.:\       :/
		+   .   .   : . ::. :.:. .:.|\  .:/|
		.         +   .  .  ...:: ..|  --.:|
.      . . .   .  .  . ... :..:.."(  ..)"
	.   .       .      :  .   .: ::/  .  .::\
	
"@
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