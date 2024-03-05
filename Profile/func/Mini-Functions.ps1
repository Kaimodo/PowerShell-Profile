## content of .\Mini-Functions.ps1 ##
<#PSScriptInfo
.VERSION 0.4
.AUTHOR Kai Krutscho
.PROJECTURI https://www.github.com/Kaimodo/PowerShell-Profile
.DESCRIPTION
    Set common Aliasses
#>
# TODO: WOrk Folder in settings.json 
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
                function global:cd... { Set-Location ..\.. }
                function global:cd.... { Set-Location ..\..\.. }

                # Compute file hashes - useful for checking successful downloads 
                function global:md5 { Get-FileHash -Algorithm MD5 $args }
                function global:sha1 { Get-FileHash -Algorithm SHA1 $args }
                function global:sha256 { Get-FileHash -Algorithm SHA256 $args }

                # Quick shortcut to start notepad
                function global:n { notepad $args }
                # Lazy Git
                function global:gcom {
                    git add .
                    git commit -m "$args"
                }
                function global:lazyg {
                    git add .
                    git commit -m "$args"
                    git push
                }

                # Drive shortcuts
                function global:HKLM: { Set-Location HKLM: }
                function global:HKCU: { Set-Location HKCU: }
                function global:Env: { Set-Location Env: }

                # Creates drive shortcut for Work Folders, if current user account is using it
                if (Test-Path "$env:USERPROFILE\Work Folders") {
                    New-PSDrive -Name Work -PSProvider FileSystem -Root "$env:USERPROFILE\Work Folders" -Description "Work Folders"
                    function global:Work: { Set-Location Work: }
                }
                # Other
                function global:touch ($file) { Write-Output "" >> $file; }
                function global:Get-PubIP{
                    Invoke-RestMethod -Uri ('http://ipinfo.io/'+(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content)
                }
                function global:whoami { (get-content env:\userdomain) + "\" + (get-content env:\username) }
                function global:nppedit ($file) { & "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe" $file }

                function global:Talk-To-Me([string]$str){
                    Add-Type -AssemblyName System.speech
                    $voice = New-Object System.Speech.Synthesis.SpeechSynthesizer
                    $voice.SelectVoice("Microsoft Zira Desktop")
                    $voice.Speak($str)
                }

                Function global:Add-ToSystemPath {            

                    Param(
                     [array]$PathToAdd
                     )
                    $VerifiedPathsToAdd = $Null
                    Foreach($Path in $PathToAdd) {            
                   
                     if($env:Path -like "*$Path*") {
                      Write-Host "Currnet item in path is: $Path" -ForegroundColor Blue
                      Write-Host "$Path already exists in Path statement" -ForegroundColor red}
                      else { $VerifiedPathsToAdd += ";$Path"
                       Write-Host "`$VerifiedPathsToAdd updated to contain: $Path"}            
                   
                     if($VerifiedPathsToAdd -ne $null) {
                      Write-Host "`$VerifiedPathsToAdd contains: $verifiedPathsToAdd"
                      Write-Host "Adding $Path to Path statement now..." -ForegroundColor Green
                      [Environment]::SetEnvironmentVariable("Path",$env:Path + $VerifiedPathsToAdd,"Process")            
                   
                      }
                     }
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
    