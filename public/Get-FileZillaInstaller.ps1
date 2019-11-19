<#
    .SYNOPSIS
    Get Filezilla

    .DESCRIPTION
    Get latest version from filezilla homepage and download lates version

    .PARAMETER Template
    A description of a parameter.

    .EXAMPLE
    Get-FileZillaInstaller
#>

Function Get-FileZillaInstaller {
    <#
         .SYNOPSIS
             Gets the download URLs for Filezilla Continuous track installers.
 
         .DESCRIPTION
             Gets the download URLs for Filezilla Continuous track installers for the latest version for Windows.
 
         .NOTES
         
  
         .EXAMPLE
             Get-FileZilla
 
             Description:
             Returns an array with version and download URL for Windows.
     #>
     
     [OutputType([System.Management.Automation.PSObject])]
     [CmdletBinding()]
     Param()
 
     $url = "https://filezilla-project.org/download.php?type=client"
 
     try {
         $web = Invoke-WebRequest -UseBasicParsing -Uri $url -ErrorAction SilentlyContinue
         $str1 = $web.tostring() -split "[`r`n]" | select-string "The latest stable version of FileZilla Client is"
         $str2 = $str1 -replace "<p>The latest stable version of FileZilla Client is "
         $Version = $str2 -replace "</p>"
         $downloadURI = 'https://download.filezilla-project.org/client/FileZilla_latest_win64-setup.exe'
  
         $PSObject = [PSCustomObject] @{
             Version  = $Version
             URI      = $downloadURI
         }
         Write-Output -InputObject $PSObject
 
 
     }
     catch {
         Throw "Failed to connect to URL: $url with error $_."
     }
 }
 
 
 