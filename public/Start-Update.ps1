<#
    .SYNOPSIS
    Install update

    .DESCRIPTION
    Update silent software based on input parameter

    .PARAMETER Template
    A description of a parameter.

    .EXAMPLE
    start-update  -InstallFilePath 'C:\download\application\setup.exe' -Parms '/S'

    .EXAMPLE
    start-update  -InstallFilePath 'C:\download\application\setup.msi' -Parms $null

    .EXAMPLE
    start-update  -InstallFilePath 'C:\download\application\setup.msp' -Parms $null
    #>

Function Start-Update {
    [CmdletBinding()]
    [OutputType([Boolean])]
    Param (
        [Parameter(Mandatory=$true)] [string]$InstallFilePath,
        [Parameter(Mandatory=$false)] [string]$Parms
                
    )
    
    
     

   $FileType =  (Get-Item $InstallFilePath).Extension
     switch ($FileType)
    {
        '.msi' { 
            $Command = "$env:systemroot\system32\msiexec.exe"             
            $Parms =  "/i `"$InstallFilePath`" /q /norestart"
            
            $Output = Start-Process -FilePath $Command -ArgumentList $Parms -Wait -PassThru
            If(($Output.Exitcode -eq 0) -or ($Output.Exitcode -eq 3010)){
                Write-Output -InputObject $True
            } else {
                Write-Output -InputObject $false
            }
        }

        '.msp' {
            $Command = "$env:systemroot\system32\msiexec.exe"   
            $Parms = "/p `"$InstallFilePath`" /q /norestart"
            $Output = Start-Process -FilePath $Command -ArgumentList $Parms -Wait -PassThru
            If(($Output.Exitcode -eq 0) -or ($Output.Exitcode -eq 3010)){
                Write-Output -InputObject $True
            } else {
                Write-Output -InputObject $false
            }
        }      

         default {
            $Command = $InstallFilePath
            $Output = Start-Process -FilePath $Command -ArgumentList $Parms -Wait -PassThru
            If(($Output.Exitcode -eq 0) -or ($Output.Exitcode -eq 3010)){
                Write-Output -InputObject $True
            } else {
                Write-Output -InputObject $false
            }

         }

    }
 

}
