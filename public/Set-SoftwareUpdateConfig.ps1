<#
    .SYNOPSIS
    Download file from url

    .DESCRIPTION
    Download file from url to a specified destination path

    .PARAMETER Template
    Invoke-DownloadFile -url http://x/file.msi -destinationFolder .\download

    .EXAMPLE
    Invoke-DownloadFile -url http://x/file.msi -destinationFolder .\download
#>
Function Set-SoftwareUpdateConfig {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false,
        ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LocalVersion = $null,

        [parameter(Mandatory = $false,
        ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LatestVersion = $null,

        [parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Software,

        [parameter(Mandatory = $false,
        ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DownloadURL
        

    ) 

    try {
        Write-Verbose -Message 'Getting content of config.json and returning as a PSCustomObject.'
        $config =  Get-SoftwareUpdateConfig
   
    } catch {
        throw "Can't find the JSON configuration file." 
    }
    
    if ($LocalVersion) {
        $config | Where-Object Software -eq $Software | ForEach-Object {$_.localversion = $LocalVersion}
    }

    if ($LatestVersion) {
        $config | Where-Object Software -eq $Software | ForEach-Object {$_.LatestVersion = $LatestVersion}
    }

    if ($DownloadURL) {
        $config | Where-Object Software -eq $Software | ForEach-Object {$_.DownloadURL = $DownloadURL}
    }

    try {
         Write-Verbose -Message 'Setting content of config.json'
         $config | ConvertTo-Json | Set-Content -Path "$PSScriptRoot\softwareConfig.json" 
    } catch {
        throw "Can't save the JSON configuration file"
    }
        
}

