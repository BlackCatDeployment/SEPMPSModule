<#
.Synopsis
    Create a group on SEPM
.DESCRIPTION
    Create a group on SEPM.
.PARAMETER Path
    Group path to create on SEPM
    !!!! CASE SENSITIVE !!!!
.PARAMETER Description
    Description of the group
.PARAMETER Inherits
    Enables or disables the group inheritance
.EXAMPLE
    New-SEPGroup -Path "My Company\Datacenter" -Description "Group for Datacenter assets"
.EXAMPLE
    New-SEPGroup -Path "My Company\Datacenter" -Inherits
#>
Function New-SEPGroup {
    PARAM(
        [Parameter(Mandatory=$true)][String] $Path,
        [Parameter(Mandatory=$false)][String] $Description,
        [Parameter(Mandatory=$false)][Switch] $Inherits
    )

    If ($Global:header -eq $null) {
        Write-Error "Use Connect-SEPM to initialize the connection first"
        return
    }
    
    $sParentGroup = Split-Path $Path -Parent
    $sGroupName = Split-Path $Path -Leaf

    $oParentGroup = Get-SEPGroup -Path $sParentGroup
    If ($oParentGroup -eq $null) {
        Write-Error "Parent Group $sParentGroup not exists!"
        return
    }

    $oGroup = Get-SEPGroup -Path $Path -WarningAction SilentlyContinue
    If ($oGroup -ne $null) {
        Write-Warning "Group $Path already exists! Nothing to do"
        return $oGroup
    }
   
    Write-Host "Creating group $sGroupName in $sParentGroup..."
    $JSON = @{
        "name" = "$($sGroupName[0..256] -join '')"
        "description" = "$($Description[0..1024] -join '')"
        "inherits" = "$Inherits"
    } | ConvertTo-Json
    try {
        Invoke-RestMethod -Uri "$Global:SEPURI/groups/$($oParentGroup.Id)" -Method Post -Body $JSON -ContentType 'application/json' -Headers $Global:header
        Write-Host "Group created"
        return (Get-SEPGroup -Path $Path)
    }
    catch {
        Write-Error "Cannot create group! $($_.Exception.Message)"
    }
}