<#
.Synopsis
    Get detailed information of a group
.DESCRIPTION
    Get detailed information of a group
.PARAMETER Content
    Group data object get from JSON
.EXAMPLE
    Get-SEPGroupInfo -Content $data
#>
Function Get-SEPGroupInfo {
    PARAM(
        [Parameter(Mandatory=$true)] $Content
    )

    try {
        $adm = (Get-SEPAdministrator -Id $Content.createdBy -WarningAction SilentlyContinue).LoginName
    }
    catch { }
    If ([String]::IsNullOrEmpty($adm)) { $adm = $Content.createdBy }

    $oGroup = [PSCustomObject]@{
        Id = $Content.id
        Path = $Content.fullPathName
        Name = $Content.name
        Description = $Content.description
        NbPhysicalComputers = $Content.numberOfPhysicalComputers
        NbRegisteredUsers = $Content.numberOfRegisteredUsers
        CreatedBy = $adm
        CreationDate = (ConvertFrom-EpochMillisec -Value $Content.created)
        LastModified = (ConvertFrom-EpochMillisec -Value $Content.lastModified)
        PolicySerialNumber = $Content.policySerialNumber
        PolicyDate = (ConvertFrom-EpochMillisec -Value $Content.policyDate)
        Domain = $Content.domain
        PolicyInheritanceEnabled = $Content.policyInheritanceEnabled
    }
    
    return $oGroup
}