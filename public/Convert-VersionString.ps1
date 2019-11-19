    <#
    .SYNOPSIS
        Splits a version number using the dots and rebuilds the string with a maximum of 4 elements (Major.Minor.Build.Revision).
    .DESCRIPTION
        Splits a version number using the dots and rebuilds the string with a maximum of 4 elements (Major.Minor.Build.Revision).
        The goal is to use this reformatted string with the [version] accelerator. Of course this function can only be used
        if it's possible to ignore everything after the 4th element.
    .PARAMETER String
        Enter the version string.
    .EXAMPLE
        Convert-VersionString -String "3.0.2.2.0"
        The result will be: 3.0.2.2      
    .Notes
        Author: Fabian Szalatnay
        Date:   13. December 2018
    #>
    
Function Convert-VersionString {

    Param (
        [Parameter(Mandatory=$true)] [string]$String
    )    
    # Set the maximum of elements in your version string
    $Digits  = 4
    # Initialize an empty version string
    $Version = ""
    # Split the string at every dot occurrence
    $Split   = $String.Split('.')
    # Check if the current number of elements is less than the maximum value, if so then set the maxium value to the current number
    if ($Split.Count -le $Digits) {$Digits = $Split.Count}
    # Loop trough the elements until you reach the maximum number minus 1 (the array starts with 0, therefore loop fom 0-3)
    for ($i=0;$i -le $Digits-1;$i++){
        # Build the new version string
        $Version = $Version + "." + $Split[$i]
    }
    # Echo the conversion result to keep you updated
    if ($Split.Count -gt $Digits) {
        Write-Log "Please note: $String was shortened to $($Version.Trim('.')) to make it 'semantic' for the [version] accelerator."
        
    }
    # Return the final version string and trim all leading and trailing dots that might occur
    Return $Version.Trim('.')
}