## content of .\cls.ps1 ##
function cls {
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