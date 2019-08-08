<#
.Synopsis
    Move group of a device on SEPM
.DESCRIPTION
    Move group of a device on SEPM.
.PARAMETER Name
    Device name
.PARAMETER Path
    Destination Group path of the device
    !!!! CASE SENSITIVE !!!!
.EXAMPLE
    Move-SEPDevice -Name "wks01" -Path "My Company\Workstations\HQ"
#>
Function Move-SEPDevice {
    PARAM(
        [Parameter(Mandatory=$true)][String] $Name,
        [Parameter(Mandatory=$true)][String] $Path
    )

    If ($Global:header -eq $null) {
        Write-Error "Use Connect-SEPM to initialize the connection first"
        return
    }

    $oDevice = Get-SEPDevice -Name $Name
    If ($oDevice -eq $null) {
        return
    }

    $oGroup = Get-SEPGroup -Path $Path
    If ($oGroup -eq $null) {
        return
    }
   
    Write-Host "Moving Device $Name from '$($oDevice.Group.name)' to '$Path'..."
    $JSON = @{
        "hardwareKey" = "$($oDevice.HardwareKey)"
        "group" = @{ "id" = "$($oGroup.Id)" }
    }
    $JSON = ConvertTo-Json @($JSON)
    try {
        Invoke-RestMethod -Uri "$Global:SEPURI/computers" -Method Patch -Body $JSON -ContentType 'application/json' -Headers $Global:header | Out-Null
        Write-Host "Device moved"
        return (Get-SEPDevice -Name $Name)
    }
    catch {
        Write-Error "Cannot move device! $($_.Exception.Message)"
    }
}