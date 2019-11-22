Write-Verbose "Importing from [$PSScriptRoot\public]"
. "$PSScriptRoot\public\Convert-VersionString.ps1"
. "$PSScriptRoot\public\Get-FileZillaInstaller.ps1"
. "$PSScriptRoot\public\Get-LocalVersion.ps1"
. "$PSScriptRoot\public\Get-SoftwareUpdateConfig.ps1"
. "$PSScriptRoot\public\Invoke-DownloadFile.ps1"
. "$PSScriptRoot\public\Set-SoftwareUpdateConfig.ps1"
. "$PSScriptRoot\public\Start-Update.ps1"
Write-Verbose "Importing from [$PSScriptRoot\private]"
. "$PSScriptRoot\private\Compare-Version.ps1"
$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\public" -Filter '*.ps1').BaseName
Export-ModuleMember -Function $publicFunctions

