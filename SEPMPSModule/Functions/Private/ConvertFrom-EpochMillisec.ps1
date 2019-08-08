<#
.Synopsis
    Convert an Epoch Millisec to Datetime
.DESCRIPTION
    Convert an Epoch Millisec to Datetime
.PARAMETER Value
    Value in milliseconds
.EXAMPLE
    ConvertFrom-EpochMillisec -Value 1562765305250
#>
Function ConvertFrom-EpochMillisec {
    PARAM(
        [Parameter(Mandatory=$true)] [Int64] $Value
    )

    $EpochStart = Get-Date -Day 1 -Month 1 -Year 1970
    $myDateTime = $EpochStart.AddMilliseconds($Value)
    
    return ([datetime]$myDateTime)
}