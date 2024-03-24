## content of .\Create-Docs.ps1 ##
using namespace System.Management.Automation.Host
$TmpLocation = $PSScriptRoot
$Out = $TmpLocation + "\Profile\doc\enUS"
$In = $TmpLocation + "\Profile\func\"

Write-Host "In: $In" -ForegroundColor Green
Write-Host "Out: $Out" -ForegroundColor Green


$filter =  "*.ps1"
$files = Get-ChildItem -path $In -filter $filter
# Iterate through the array and call New-MarkdownHelp -Command for each function
foreach ($file in $files) {
    Write-Host $file.BaseName
    $OutName = $Out + "\" + $file.BaseName + ".md"
    Write-Host $OutName
    .\Profile\func\Get-MarkdownHelp.ps1  $file.FullName | Out-String | Set-Content $OutName 
    
}