<#
.Synopsis
    Get SEP API version
.DESCRIPTION
    Get SEP API version
.EXAMPLE
    Get-SEPAPIVersion
.OUTPUTS
    Return an object containing following properties:
        - APIVersion: Version of the API
        - SEPMVersion: Version of SEPM hosting the API
#>
Function Get-SEPAPIVersion {
    If ($Global:header -eq $null) {
        Write-Error "Use Connect-SEPM to initialize the connection first"
        return
    }

    try {
        $APIInfo = Invoke-WebRequest -Uri "$Global:SEPURI/version" -Method Get
    }
    catch {
        Write-Error "$($_.Exception.Message)"
        return
    }

    $oContent = ConvertTo-CustomObject $APIInfo.Content
    If ($oContent -ne $null) {
        $oVersion = [PSCustomObject]@{
            APIVersion = $oContent.API_VERSION
            SEPMVersion = $oContent.version
        }
        return $oVersion
    }
}