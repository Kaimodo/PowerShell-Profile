## content of .\Template.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Default Script Template
#>
using namespace System.Management.Automation.Host
#https://www.sharepointdiary.com/2021/11/progress-bar-in-powershell.html

[CmdletBinding(SupportsShouldProcess=$true)]
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
		#TODO: Start Here:
			
		#Snipet
		$answer = $Host.UI.PromptForChoice('title', 'question', @('&Yes', '&No'), 1)
		if ($answer -eq 0) {
			#yes
			Write-Host 'YES'
		}else{
			#no
			Write-Host 'NO'
		}
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