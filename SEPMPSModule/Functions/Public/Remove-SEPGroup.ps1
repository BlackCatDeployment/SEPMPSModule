<#
.Synopsis
    Remove group from SEPM
.DESCRIPTION
    Remove group from SEPM.
    This cmdlet not removes a group if computers or users still remain on it.
    If -Force parameter is set, the previous condition is bypassed
.PARAMETER Path
    Group path to remove from SEPM
    !!!! CASE SENSITIVE !!!!
.PARAMETER Force
    Force removal
.EXAMPLE
    Remove-SEPGroup -Path "My Company\Datacenter"
.EXAMPLE
    Remove-SEPGroup -Path "My Company\Datacenter" -Confirm:$false
.EXAMPLE
    Remove-SEPGroup -Path "My Company\Datacenter" -Force
#>
Function Remove-SEPGroup {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    PARAM(
        [Parameter(Mandatory=$true)][String] $Path,
        [Parameter(Mandatory=$false)][Switch] $Force
    )

    If ($Global:header -eq $null) {
        Write-Error "Use Connect-SEPM to initialize the connection first"
        return
    }
    
    $oGroup = Get-SEPGroup -Path $Path

    If ($oGroup -ne $null) {
        If ($Force) { $bRemove = $true }
        ElseIf ($PSCmdlet.ShouldProcess("$Path",'Remove')) { $bRemove = $true }

        If ($bRemove) {
            If ($Force -or (($oGroup.NbPhysicalComputers -eq 0) -and ($oGroup.NbRegisteredUsers -eq 0))) {
                Write-Host "Removing group $($oGroup.Name) (Path: $Path)..."
                try {
                    Invoke-RestMethod -Uri "$Global:SEPURI/groups/$($oGroup.Id)" -Method Delete -Headers $Global:header
                    Write-Host "Group removed"
                }
                catch {
                    Write-Error "Cannot remove group! $($_.Exception.Message)"
                }
            }
            Else {
                Write-Warning "Group not removed because $($oGroup.NbPhysicalComputers) Computers or $($oGroup.NbRegisteredUsers) Users still exist on it"
            }
        }
    }
}