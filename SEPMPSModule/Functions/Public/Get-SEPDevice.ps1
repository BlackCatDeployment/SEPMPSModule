<#
.Synopsis
    Get device from SEPM
.DESCRIPTION
    Get device from SEPM
.PARAMETER Name
    Device name
.EXAMPLE
    Get-SEPDevice
.EXAMPLE
    Get-SEPDevice -Name "wks01"
#>
Function Get-SEPDevice {
    PARAM(
        [Parameter(Mandatory=$false)][String] $Name
    )

    If ($Global:header -eq $null) {
        Write-Error "Use Connect-SEPM to initialize the connection first"
        return
    }

    try {
        $aDevices = @()
        If ([String]::IsNullOrEmpty($Name)) {
            $totalPages = 20 #For initialization
            For ($i=1; $i -le $totalPages; $i++) {
                Write-Progress -Activity "Getting devices..." -Status "$([math]::Round(($i/$totalPages)*100))% Complete:" -PercentComplete $([math]::Round(($i/$totalPages)*100)) -Id 1
                $deviceInfo = Invoke-WebRequest -Uri "$Global:SEPURI/computers?pageSize=1000&pageIndex=$i" -Method Get -Headers $Global:header
                $oContent = ConvertTo-CustomObject $deviceInfo.Content
                $j = 1
                ForEach ($device in $oContent.content) {
                    Write-Progress -Activity "Getting info..." -Status "Device $($device.computerName)" -PercentComplete $([math]::Round(($j/$oContent.content.Count)*100)) -ParentId 1
                    $aDevices += @(Get-SEPDeviceInfo -Content $device)
                    $j++
                }
                Write-Progress -Activity "Getting info..." -Completed

                $totalPages = $oContent.totalPages
            }
            Write-Progress -Activity "Getting devices..." -Completed
        }
        Else {
            $deviceInfo = Invoke-WebRequest -Uri "$Global:SEPURI/computers?computerName=$Name" -Method Get -Headers $Global:header
            $oContent = ConvertTo-CustomObject $deviceInfo.Content
            $aDevices += @(Get-SEPDeviceInfo -Content $oContent.content)
        }
    }
    catch {
        Write-Error "$($_.Exception.Message)"
        return
    }

    If ($oContent.totalElements -eq 0) {
        Write-Warning "No $Name Device found in SEPM!"
        return $null
    }

    If (-not [String]::IsNullOrEmpty($Name)) {
        Write-Host "Found $($oContent.totalElements) device(s) matching the name $Name"
    }
    Else {
        Write-Host "Found $($oContent.totalElements) device(s)"
    }

    return ($aDevices | Sort-Object -Property Name)
}