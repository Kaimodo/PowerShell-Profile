## content of .\Aliasses.ps1 ##
<#PSScriptInfo
.VERSION 0.3
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Set common Aliasses
#>
Set-ALias -Name dir -Value Get-CHildItem -Option AllScope
Set-ALias -Name ls -Value Get-CHildItem -Option AllScope
Set-ALias cdirl Get-ChildItem | Format-List
Set-Alias sudo Invoke-Elevated
Set-Alias rm Remove-ItemSafely -Option AllScope