## content of .\Write-StartScreen.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Shows StartScreen
#>
function Write-StartScreen {
<#
	.SYNOPSIS
		Shows a SpashScreen
	.DESCRIPTION
		Shows a SpashScreen on start of PowerShell
	.EXAMPLE
		PS> ./Write-StartScreen.ps1
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
			$ipaddress = [System.Net.DNS]::GetHostByName($null)
			foreach($ip in $ipaddress.AddressList){
				#if ($ip.AddressFamily -eq 'InterNetwork')
				#  {
				#	$ModernConsole_IPv4Address = $ip.IPAddressToString
				#	break
				#}
				if ($ip.IPAddressToString -like "*178*")
				{
					$ModernConsole_IPv4Address = $ip.IPAddressToString
					break
				}
			}


			# PSVersion (e.g. 5.0.10586.494 or 4.0)
			if($PSVersionTable.PSVersion.Major -gt 4)
			{
				$ModernConsole_PSVersion = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Build).$($PSVersionTable.PSVersion.Revision)"
			}
			else 
			{
				$ModernConsole_PSVersion = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
			}
			$EmptyConsoleText = @"
	
                                        ____                        ____  _          _ _     
     SS                                     |  _ \ _____      _____ _ __/ ___|| |__   ___| | |    
     SSSSS                                  | |_) / _ \ \ /\ / / _ \ '__\___ \| '_ \ / _ \ | |    
     SSSSSSSS                               |  __/ (_) \ V  V /  __/ |   ___) | | | |  __/ | |    
     SSSSSSSSSSS                            |_|   \___/ \_/\_/ \___|_|  |____/|_| |_|\___|_|_|    
        SSSSSSSSSSS                                                                             
           SSSSSSSSSSS              +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
              SSSSSSSSSSS           |
               SSSSSSSSSS           |   Domain\Username  :  $env:USERDOMAIN\$env:USERNAME     
              SSSSSSSSSSS           |   Hostname         :  $([System.Net.Dns]::GetHostEntry([string]$env:computername).HostName)
           SSSSSSSSSSS              |   IPv4-Address     :  $ModernConsole_IPv4Address
        SSSSSSSSSSS                 |   PSVersion        :  $ModernConsole_PSVersion
     SSSSSSSSSSS                    |   Date & Time      :  $(Get-Date -Format F) 
     SSSSSSSS                       |                   
     SSSSS      SSSSSSSSSSSSSSS     +=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
     SS      SSSSSSSSSSSSSSS                                          [https://GitHub.com/Kaimodo] 
                                                                                

"@

			Write-Host -Object $EmptyConsoleText
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
