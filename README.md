# SEPMPSModule
Symantec Endpoint Protection Manager PowerShell Module

## Introduction

Official Symantec API Documentation: https://apidocs.symantec.com/home/saep#_symantec_endpoint_protection_manager_rest_api_reference

This module uses the SEPM API to perform operations.

To use it, open a PowerShell console and enter:

**Import-Module "\<*path*\>\SEPMPSModule"**
  
**Connect-SEPM -Name "\<*srv_sepm.fqdn*\>"**

## Available cmdlets
Name | Description
---- | ------
Connect-SEPM | Connect to SEPM (mandatory to use others cmdlets)
Get-SEPAdministrator | Get SEPM Administrators
Get-SEPAPIVersion | Get SEPM version and its API version
Get-SEPDevice | Get device(s) assigned to SEPM
Get-SEPGroup | Get SEPM group(s)
Move-SEPDevice | Move a device from a group to another
New-SEPGroup | Create a new SEPM group
Remove-SEPDevice | Remove a device from SEPM
Remove-SEPGroup | Remove a SEPM group

## Cmdlet documentation
Each cmdlet is documented. Enter: **Get-Help \<*SEPMPScmdlet*\>** to view how to use it.
