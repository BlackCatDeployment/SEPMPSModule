<#
.Synopsis
    Get SEP Administrators
.DESCRIPTION
    Get SEP Administrators. Can be an admin or a list of all admins
.PARAMETER Name
    Administrator Login Name
.EXAMPLE
    Get-SEPAdministrator
.EXAMPLE
    Get-SEPAdministrator -Name "sepadm"
.EXAMPLE
    Get-SEPAdministrator -Id "F31D6F79C0A86A71249BBA2C430D99C7"
.OUTPUTS
    Return an object containing following properties:
        - LoginName: Admin login name
        - FullName: Admin full name
        - Email: Admin mail address
        - Enabled: Boolean of account state
        - Locked: Boolean of account state
        - AdminType: Type of account (1: SysAdmin, 2: Admin, 3: Limited Admin)
        - LastLogonIP: Last logon IP address
#>
Function Get-SEPAdministrator {
    PARAM(
        [Parameter(Mandatory=$false)][String] $Name,
        [Parameter(Mandatory=$false)][String] $Id
    )

    If ($Global:header -eq $null) {
        Write-Error "Use Connect-SEPM to initialize the connection first"
        return
    }

    try {
        If ([String]::IsNullOrEmpty($Id)) {
            $AdminInfo = Invoke-WebRequest -Uri "$Global:SEPURI/admin-users" -Method Get -Headers $Global:header
        }
        Else {
            try {
                $AdminInfo = Invoke-WebRequest -Uri "$Global:SEPURI/admin-users/$Id" -Method Get -Headers $Global:header
            }
            catch {
                # To avoid an error when no admin found
            }
        }
    }
    catch {
        Write-Error "$($_.Exception.Message)"
        return
    }

    If ($AdminInfo -ne $null) {
        $oContent = ConvertTo-CustomObject $AdminInfo.Content
        If (-not [String]::IsNullOrEmpty($Name)) {
            $oContent = $oContent | ? { $_.loginName -eq $Name }
        }

        $aAdmins = @()
        ForEach ($adm in $oContent) {
            Switch ($adm.adminType) {
                1 { $admType = "SysAdmin" }
                2 { $admType = "Admin" }
                3 { $admType = "LimitedAdmin" }
                Default { $admType = "Unknown ( $($adm.adminType) )" }
            }
            $aAdmins += @([PSCustomObject]@{
                Id = $adm.id
                LoginName = $adm.loginName
                FullName = $adm.fullName
                Email = $adm.email
                Enabled = $adm.enabled
                Locked = $adm.lockAccount
                AdminType = $admType
                LastLogonIP = $adm.lastLogonIP
            })
        }

        return $aAdmins
    }
    Else {
        Write-Warning "No Admin found in SEPM!"
        return $null
    }
}