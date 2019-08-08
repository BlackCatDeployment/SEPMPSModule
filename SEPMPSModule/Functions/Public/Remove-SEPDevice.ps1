<#
.Synopsis
    Remove device from SEPM
.DESCRIPTION
    Remove device from SEPM.
    This cmdlet also remove duplicate records for a device.
.PARAMETER Name
    Device name to remove from SEPM
.PARAMETER Force
    Force removal
.PARAMETER Aged
    Last contact with SEPM before deletion (default: 30 days)
.EXAMPLE
    Remove-SEPDevice -Name "wks01"
.EXAMPLE
    Remove-SEPDevice -Name "wks01" -Confirm:$false
.EXAMPLE
    Remove-SEPDevice -Name "wks01" -Aged 7
.EXAMPLE
    Remove-SEPDevice -Name "wks01" -Force
#>
Function Remove-SEPDevice {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    PARAM(
        [Parameter(Mandatory=$true)][String] $Name,
        [Parameter(Mandatory=$false)][Switch] $Force,
        [Parameter(Mandatory=$false)][Int] $Aged = 30
    )

    If ($Global:header -eq $null) {
        Write-Error "Use Connect-SEPM to initialize the connection first"
        return
    }
    
    $oDevice = Get-SEPDevice -Name $Name

    If ($oDevice -ne $null) {
        If ($Force) { $bRemove = $true }
        ElseIf ($PSCmdlet.ShouldProcess("$Name",'Remove')) { $bRemove = $true }

        If ($bRemove) {
            ForEach ($item in $oDevice) {
                If ($Force -or ($item.LastUpdateTime -le (Get-Date).AddDays(-$Aged))) {
                    Write-Host "Removing device $Name with UUID $($item.Id)..."
                    try {
                        Invoke-RestMethod -Uri "$Global:SEPURI/computers/$($item.Id)" -Method Delete -Headers $Global:header | Out-Null
                        Write-Host "Device removed"
                    }
                    catch {
                        Write-Error "Cannot remove device! $($_.Exception.Message)"
                    }
                }
                Else {
                    Write-Warning "Device not removed because contacted SEPM for less than $Aged days"
                }
            }
        }
    }
}