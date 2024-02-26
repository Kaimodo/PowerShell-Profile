## content of .\Write-StartScreen.ps1 ##
function Write-StartScreen {
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
            Write-Verbose "$($FunctionName): Process.catch"
            Write-Output $_.Exception|format-list -force
        }
	}
	end {
			Write-Verbose "$($FunctionName): End."
			$ErrorActionPreference = $TempErrAct
	}
}
