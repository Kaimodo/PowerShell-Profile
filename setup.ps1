## content of .\setup.ps1 ##
<#PSScriptInfo
.VERSION 0.1
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Default Script Template
#>
#TODO: - Write whole Setup Script
#Requires -RunAsAdministrator
using namespace System.Management.Automation.Host

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