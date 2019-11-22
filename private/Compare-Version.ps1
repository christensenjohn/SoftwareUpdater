<#
    .SYNOPSIS
    compare versions

    .DESCRIPTION
    compare file local with evergreen version. Return false if vesrion is not equal

    .PARAMETER Template
    A description of a parameter.

    .EXAMPLE
    Compare-Version 
#>

function Compare-Version {
    Param (
    $Reference,
    $Difference
    )

    $result = Compare-Object -ReferenceObject $Reference -DifferenceObject $Difference -IncludeEqual
    if ($result.SideIndicator -eq '==') {
        return $true
    } else {
        return $false
    }
   
}  
