#Thanks to Aaron Parker for Evergreen
#https://www.powershellgallery.com/profiles/aaronparker
#https://www.powershellgallery.com/packages/Evergreen


 
IF ([Environment]::OSVersion.Version -ge (new-object 'Version' 6,2)) {
$osInstalled = "WIN10"
}  else {$osInstalled = "WIN7"}


if (!(Get-InstalledModule -Name 'EverGreen' -ErrorAction 'SilentlyContinue')) {
    Install-Module -Name 'EverGreen' -Force
}

Update-Module evergreen -force



Import-Module -Name 'EverGreen'
Import-Module 'C:\scripts\SoftwareUpdater\output\SoftwareUpdater' -Force



$LatestGoogleChrome = Get-GoogleChrome | Where-Object -FilterScript {$_.platform -eq 'win'}
Set-SoftwareUpdateConfig -Software 'GoogleChrome' -LatestVersion $LatestGoogleChrome.Version 
Set-SoftwareUpdateConfig -Software 'GoogleChrome' -DownloadURL $LatestGoogleChrome.URI 

$LatestAdobeAcrobatReaderDC = Get-AdobeAcrobatReaderDC | Where-Object -FilterScript {($_.Platform -eq 'Windows') -and ($_.Type -eq 'Updater')-and ($_.Language -eq 'Neutral')} 
Set-SoftwareUpdateConfig -Software 'AdobeAcrobatReaderDC' -LatestVersion $LatestAdobeAcrobatReaderDC.Version 
Set-SoftwareUpdateConfig -Software 'AdobeAcrobatReaderDC' -DownloadURL $LatestAdobeAcrobatReaderDC.URI 

$LatestFilezilla = Get-FileZillaInstaller 
Set-SoftwareUpdateConfig -Software 'FileZilla' -LatestVersion $LatestFilezilla.Version 
Set-SoftwareUpdateConfig -Software 'FileZilla' -DownloadURL $LatestFilezilla.URI 

$LatestVideoLanVlcPlayer = Get-VideoLanVlcPlayer | Where-Object -FilterScript {($_.platform -eq 'windows')-and ($_.type -eq 'msi') -and $_.Architecture -eq 'x86'}
Set-SoftwareUpdateConfig -Software 'VideoLanVlcPlayer' -LatestVersion $LatestVideoLanVlcPlayer.Version 
Set-SoftwareUpdateConfig -Software 'VideoLanVlcPlayer' -DownloadURL $LatestVideoLanVlcPlayer.URI 



#Update  Local version table
Get-SoftwareUpdateConfig | Where-Object -FilterScript {(($_.OS -EQ 'ALL') -or ($_.OS -eq $osInstalled)) } | ForEach-Object {    
    $LocalVersion = (Get-LocalVersion -program $_.Software  -FileVersionPath $_.FileVersionPath).LocalVersion
        Set-SoftwareUpdateConfig -Software $_.Software -LocalVersion $LocalVersion
}

#Create a list of software that needs updates
$SoftwareToBeUpdated = @()
Get-SoftwareUpdateConfig | Where-Object -FilterScript {(($_.OS -EQ 'ALL') -or ($_.OS -eq $osInstalled)) -and $_.LatestVersion -ne "" -and $_.LocalVersion -ne 'Not found'} | ForEach-Object {  

    if ([version](Convert-VersionString -String $_.LatestVersion) -gt [version](Convert-VersionString -String $_.LocalVersion)) {
        $SoftwareToBeUpdated += $($_.software)

        }
}




#$SoftwareToBeUpdated = 'VideoLanVlcPlayer'
foreach ($SoftwareName in $SoftwareToBeUpdated) {
    $installparameter = (Get-SoftwareUpdateConfig | Where-Object -FilterScript {$_.software -eq $softwarename} | Select-Object SilentInstallation).SilentInstallation
 
    if ($SoftwareName -eq 'AdobeAcrobatReaderDC' ) {
        Write-Output "Downloading $($LatestAdobeAcrobatReaderDC.URI)"
        $result = (Invoke-DownloadFile -url $LatestAdobeAcrobatReaderDC.URI ".\Download\$Softwarename")        
        if ($($result.DownloadFileStatus) -eq 'True'){
             Write-Output "Installing $($result.DownloadFileName)"
            if (-not(Start-Update -InstallFilePath $($result.DownloadFileNamePath) -Parms $null)) {
                Write-Output "Installation failed"
            }
        }
    }
    if ($SoftwareName -eq 'GoogleChrome' ) {
        Write-Output "Downloading $($LatestGoogleChrome.URI)"
        $result = (Invoke-DownloadFile -url $LatestGoogleChrome.URI ".\Download\$Softwarename")        
        if ($($result.DownloadFileStatus) -eq 'True'){
            Write-Output "Installing $($result.DownloadFileName)"
            if (-not(Start-Update -InstallFilePath $($result.DownloadFileNamePath) -Parms $null)) {
                Write-Output "Installation failed"
            }
        }
    }

    if ($SoftwareName -eq 'FileZilla' ) {
        Write-Output "Downloading $($LatestFileZilla.URI)"
        $result = (Invoke-DownloadFile -url $LatestFileZilla.URI -destination ".\Download\$Softwarename") 
        if ($($result.DownloadFileStatus) -eq 'True'){
            Write-Output "Installing $($result.DownloadFileName)"
            if (-not(Start-Update -InstallFilePath $($result.DownloadFileNamePath) -Parms $installparameter)) {
                Write-Output "Installation failed"
            }
        }
    }

    if ($SoftwareName -eq 'VideoLanVlcPlayer' ) {
        Write-Output "Downloading $($VideoLanVlcPlayer.URI)"
        $result = (Invoke-DownloadFile -url $LatestVideoLanVlcPlayer.URI -destination ".\Download\$Softwarename") 
        if ($($result.DownloadFileStatus) -eq 'True'){
             Write-Output "Installing $($result.DownloadFileName)"
            if (-not(Start-Update -InstallFilePath $($result.DownloadFileNamePath) -Parms $null)) {
                Write-Output "Installation failed"
            }
        }
    }

} 


#Update  Local version table
Get-SoftwareUpdateConfig | Where-Object -FilterScript {(($_.OS -EQ 'ALL') -or ($_.OS -eq $osInstalled)) } | ForEach-Object {    
    $LocalVersion = (Get-LocalVersion -program $_.Software  -FileVersionPath $_.FileVersionPath).LocalVersion
    Set-SoftwareUpdateConfig -Software $_.Software -LocalVersion $LocalVersion
}

Remove-Module SoftwareUpdater


