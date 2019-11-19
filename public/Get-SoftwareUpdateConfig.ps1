<#
    .SYNOPSIS
    A brief description of this function.

    .DESCRIPTION
    A detailed description of this function.

    .PARAMETER Template
    A description of a parameter.

    .EXAMPLE
    An example of this function's usage.
#>

function Get-SoftwareUpdateConfig {
    [CmdletBinding()]
    Param()

    try {
        Write-Verbose -Message 'Getting content of config.json and returning as a PSCustomObject.'
        $config = Get-Content -Path "$PSScriptRoot\softwareConfig.json" -ErrorAction 'Stop' | ConvertFrom-Json
   

        return $config
    } catch {
        throw "Can't find the JSON configuration file."
    }
}