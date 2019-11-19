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
function Invoke-DownloadFile {
    [OutputType([System.Management.Automation.PSObject])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true,
               ValueFromPipeline = $true,
               HelpMessage = 'Download url')]     
        [ValidateNotNullOrEmpty()]  
        [ValidateScript({
            If ($_ -match "(http[s]?|[s]?ftp[s]?)(:\/\/)([^\s,]+)") {
                $True
            }
            else {
                Throw "$_ is not a valid url"
            }
        })]
        [string]$url,

        [Parameter(Mandatory = $false,
               ValueFromPipeline = $true)]        
        [string]$destination = (Split-Path $script:MyInvocation.MyCommand.Path)

  )

  $destination= (Split-Path $destination)
  
    if (-not (Test-Path -LiteralPath $destination)) {
    
       try {
            New-Item -Path $destination -ItemType Directory -ErrorAction Stop | Out-Null #-Force           
        }
        catch {
            Write-Error -Message "Unable to create directory '$destination'. Error was: $_" -ErrorAction Stop
        }   
    }

    $DownloadFileName = $($url -split ('/')) | Select-Object -Last 1
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $destination\$DownloadFileName -ErrorAction Stop   
        $destinationPath = Resolve-Path -Path $destination
        
        if (Test-Path  "$destinationPath\$DownloadFileName"){
            $DownloadFileStatus = $true
        } else {
            $DownloadFileStatus = $false
        }
         
        $PSObject = [PSCustomObject] @{
            DownloadFileName     = $DownloadFileName
            DownloadFileNamePath = "$destinationPath\$DownloadFileName"
            DownloadFileStatus =  $DownloadFileStatus
        }
        Write-Output -InputObject $PSObject

    } catch {        
        Throw "Failed to connect to URL: $url with error $_."
        $DownloadFileStatus = $false
    }
    
    
    
}
