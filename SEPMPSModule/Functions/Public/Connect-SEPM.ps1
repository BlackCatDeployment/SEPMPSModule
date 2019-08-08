<#
.Synopsis
    Connect to SEPM
.DESCRIPTION
    Connect to SEPM
.PARAMETER Name
    FQDN of SEPM
.EXAMPLE
    Connect-SEPM -Name "sepsrv.domain.local"
.EXAMPLE
    Connect-SEPM -Name "sepsrv.domain.local" -Port 8446
.EXAMPLE
    $creds = Get-Credential
    Connect-SEPM -Name "sepsrv.domain.local" -Credential $creds
#>
Function Connect-SEPM {
    PARAM(
        [Parameter(Mandatory=$true)][String] $Name,
        [Parameter(Mandatory=$false)][Int32] $Port = 8446,
        [Parameter(Mandatory=$false)][System.Management.Automation.PSCredential] $Credential
    )

    Test-Port -Computer $Name -Port $Port -ExitOnError | Out-Null

    # Base URI to SEP API
    $Global:SEPURI = "https://$($Name):$Port/sepm/api/v1"

    # To allow connection with an unsigned SSL certificate
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $certCallback = @"
        using System;
        using System.Net;
        using System.Net.Security;
        using System.Security.Cryptography.X509Certificates;
        public class ServerCertificateValidationCallback {
            public static void Ignore() {
                if(ServicePointManager.ServerCertificateValidationCallback ==null) {
                    ServicePointManager.ServerCertificateValidationCallback += 
                        delegate
                        (
                            Object obj, 
                            X509Certificate certificate, 
                            X509Chain chain, 
                            SslPolicyErrors errors
                        )
                        {
                            return true;
                        };
                }
            }
        }
"@
    Add-Type $certCallback
    [ServerCertificateValidationCallback]::Ignore()


    # Authentication
    If ($Credential -eq $null) {
        $Credential = Get-Credential
    }
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password)
    $UnsecPwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    $cred = @{
        username = $Credential.UserName
        password = $UnsecPwd
        domain = ""
    }
    #converts $cred array to json to send to the SEPM
    $auth = $cred | ConvertTo-Json
    try {
        $userAuth = Invoke-RestMethod -Uri "$SEPURI/identity/authenticate" -Method Post -Body $auth -ContentType 'application/json'
    }
    catch {
        Write-Error "Not allowed to connect to SEP API with user $($Credential.UserName)! $($_.Exception.Message)"
        return
    }

    Write-Host "Connected as $($userAuth.username) ($($userAuth.domain))"
    If ($userAuth.role.title -ne "sysadmin") {
        #SysAdmin is required even for get computer info....
        Write-Error "The user must be SysAdmin to use SEP API!"
        return
    }

    $Global:header = @{ Authorization = 'Bearer ' + $userAuth.token }
}