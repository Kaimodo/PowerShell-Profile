## content of .\Template.test.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Test File
#>
[CmdletBinding()]
Param()

begin {
	$FunctionName = $MyInvocation.MyCommand.Name
    Write-Verbose "$($FunctionName): Begin."
    $TempErrAct = $ErrorActionPreference
    $ErrorActionPreference = "Stop"
	$Module = (Get-Content ($PSScriptRoot + "./Profile/modules.json") -Raw) | ConvertFrom-Json 
	
}
process {
	try {
		Write-Verbose "$($FunctionName):Process"
		#TODO: Start Here:
		
		
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