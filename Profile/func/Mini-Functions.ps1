## content of .\Mini-Functions.ps1 ##
<#PSScriptInfo
.VERSION 0.4
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Set common Aliasses
#>
function Mini-Functions {
    <#
        .SYNOPSIS
            Set's Common mini functions
        .DESCRIPTION
            Set's Common mini functions for easier use
        .EXAMPLE
            PS> ./Mini-Functions.ps1
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
                # Useful shortcuts for traversing directories
                #TODO: Functions not working as intended
                # https://www.donnfelker.com/loading-powershell-profiles-from-other-script-files/
                function cd... { Set-Location ..\.. }
                function cd.... { Set-Location ..\..\.. }

                # Compute file hashes - useful for checking successful downloads 
                function md5 { Get-FileHash -Algorithm MD5 $args }
                function sha1 { Get-FileHash -Algorithm SHA1 $args }
                function sha256 { Get-FileHash -Algorithm SHA256 $args }

                # Quick shortcut to start notepad
                function n { notepad $args }

                # Drive shortcuts
                function HKLM: { Set-Location HKLM: }
                function HKCU: { Set-Location HKCU: }
                function Env: { Set-Location Env: }

                # Creates drive shortcut for Work Folders, if current user account is using it
                if (Test-Path "$env:USERPROFILE\Work Folders") {
                    New-PSDrive -Name Work -PSProvider FileSystem -Root "$env:USERPROFILE\Work Folders" -Description "Work Folders"
                    function Work: { Set-Location Work: }
                }

                function Get-PubIP{
                    Invoke-RestMethod -Uri ('http://ipinfo.io/'+(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content)
                }
                function whoami { (get-content env:\userdomain) + "\" + (get-content env:\username) }
                function nppedit ($file) { & "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe" $file }

                function Talk-To-Me([string]$str){
                    Add-Type -AssemblyName System.speech
                    $voice = New-Object System.Speech.Synthesis.SpeechSynthesizer
                    $voice.SelectVoice("Microsoft Zira Desktop")
                    $voice.Speak($str)
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
    }
    