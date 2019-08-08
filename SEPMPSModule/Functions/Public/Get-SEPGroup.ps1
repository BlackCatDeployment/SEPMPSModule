<#
.Synopsis
    Get group from SEPM
.DESCRIPTION
    Get group from SEPM
.PARAMETER Path
    Group path to get from SEPM
    !!!! CASE SENSITIVE !!!!
.EXAMPLE
    Get-SEPGroup
.EXAMPLE
    Get-SEPGroup -Path "My Company\DATACENTER"
#>
Function Get-SEPGroup {
    PARAM(
        [Parameter(Mandatory=$false)][String] $Path
    )

    If ($Global:header -eq $null) {
        Write-Error "Use Connect-SEPM to initialize the connection first"
        return
    }

    try {
        $aGroups = @()
        If ([String]::IsNullOrEmpty($Path)) {
            $totalPages = 20 #For initialization
            For ($i=1; $i -le $totalPages; $i++) {
                Write-Progress -Activity "Getting groups..." -Status "$([math]::Round(($i/$totalPages)*100))% Complete:" -PercentComplete $([math]::Round(($i/$totalPages)*100)) -Id 1
                $groupInfo = Invoke-WebRequest -Uri "$Global:SEPURI/groups?pageSize=100&pageIndex=$i" -Method Get -Headers $Global:header
                $oContent = ConvertTo-CustomObject $groupInfo.Content
                $j = 1
                ForEach ($grp in $oContent.content) {
                    Write-Progress -Activity "Getting info..." -Status "Group $($grp.fullPathName)" -PercentComplete $([math]::Round(($j/$oContent.content.Count)*100)) -ParentId 1
                    $aGroups += @(Get-SEPGroupInfo -Content $grp)
                    $j++
                }
                Write-Progress -Activity "Getting info..." -Completed
                $totalPages = $oContent.totalPages
            }
            Write-Progress -Activity "Getting groups..." -Completed
        }
        Else {
            $groupInfo = Invoke-WebRequest -Uri "$Global:SEPURI/groups?fullPathName=$Path" -Method Get -Headers $Global:header
            $oContent = ConvertTo-CustomObject $groupInfo.Content

            $aGroups += @(Get-SEPGroupInfo -Content $oContent.content)
        }
    }
    catch {
        Write-Error "$($_.Exception.Message)"
        return
    }

    If ($oContent.totalElements -eq 0) {
        Write-Warning "No $Path Group found in SEPM!"
        return $null
    }

    If (-not [String]::IsNullOrEmpty($Path)) {
        Write-Host "Found $($oContent.totalElements) group(s) matching the name $Path"
    }
    Else {
        Write-Host "Found $($oContent.totalElements) group(s)"
    }

    return ($aGroups | Sort-Object -Property Path)
}