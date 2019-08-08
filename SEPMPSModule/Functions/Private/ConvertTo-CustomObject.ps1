<#
.Synopsis
    Convert an Invoke-WebRequest output to a custom object
.DESCRIPTION
    Convert an Invoke-WebRequest output to a custom object
.PARAMETER InputObject
    Input object to convert
.EXAMPLE
    ConvertTo-CustomObject -Content $data
#>
Function ConvertTo-CustomObject {
    PARAM(
        [Parameter(Mandatory=$true)] $Content
    )

    # In case of string contains duplicated keys
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
    $oContent = (New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer -Property @{MaxJsonLength=67108864}).DeserializeObject($Content)
    
    return $oContent
}