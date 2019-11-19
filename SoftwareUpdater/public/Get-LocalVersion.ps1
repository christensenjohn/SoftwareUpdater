<#
    .SYNOPSIS
    return file version.

    .DESCRIPTION
    Return version of file

    .PARAMETER Template
    A description of a parameter.

    .EXAMPLE
    Get-LocalVersion C:\program files\software\file.exe
#>

function Get-LocalVersion {
    [OutputType([System.Management.Automation.PSObject])]
    Param (
    $program,
    $FileVersionPath
    )

    switch ($program)
    {
        'AdobeAcrobatReaderDC' {             
            $LocalFileVersion = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* `
            | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | `
            Where-Object{$_.DisplayName -like "*Adobe*" -and $_.DisplayName -like "*Reader*"}).displayversion
            if (-not($LocalFileVersion)){
                $LocalFileVersion = "Not found"
            }

        }
        default {
	        if (test-path $FileVersionPath) {
                $LocalFileVersion = ((Get-Item $FileVersionPath).VersionInfo.FileVersion -replace ",","." ) `
                 -replace " ",""                
            } else {
                $LocalFileVersion = "Not found"
            }   
        }

    }
    $PSObject = [PSCustomObject] @{
        LocalVersion  = $LocalFileVersion
        Program = $program
    }
    Write-Output -InputObject $PSObject
}  

