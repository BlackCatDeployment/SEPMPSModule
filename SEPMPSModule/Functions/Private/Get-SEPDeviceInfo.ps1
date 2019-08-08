<#
.Synopsis
    Get detailed information of a device
.DESCRIPTION
    Get detailed information of a device
.PARAMETER Content
    Device data object get from JSON
.EXAMPLE
    Get-SEPDeviceInfo -Content $data
#>
Function Get-SEPDeviceInfo {
    PARAM(
        [Parameter(Mandatory=$true)] $Content
    )

    $oDevice = [PSCustomObject]@{
        Id = $Content.uniqueId
        Name = $Content.computerName
        Description = $Content.description
        Group = $Content.group
        IPAddresses = $Content.ipAddresses
        MACAddresses = $Content.macAddresses
        Gateways = $Content.gateways
        SubnetMasks = $Content.subnetMasks
        DNSServers = $Content.dnsServers
        WINSServers = $Content.winServers
        LogonUserName = $Content.logonUserName
        DomainOrWorkgroup = $Content.domainOrWorkgroup
        ProcessorType = $Content.processorType
        ProcessorClock = $Content.processorClock
        PhysicalCPUs = $Content.physicalCpus
        LogicalCPUs = $Content.logicalCpus
        Memory = $Content.memory
        FreeMemory = $Content.freeMem
        DiskDrive = $Content.diskDrive
        FreeDisk = $Content.freeDisk
        BIOSVersion = $Content.biosVersion
        OSFunction = $Content.osFunction
        OSFlavorNumber = $Content.osFlavorNumber
        OSName = $Content.osName
        OSFullName = $Content.operatingSystem
        OSVersion = $Content.osVersion
        OSMajorVersion = $Content.osMajor
        OSMinorVersion = $Content.osMinor
        OSServicePack = $Content.osServicePack
        OSArchitecture = $Content.osBitness
        OSLanguage = $Content.osLanguage
        HardwareKey = $Content.hardwareKey
        UUID = $Content.uuid
        TotalDiskSpace = $Content.totalDiskSpace
        DeploymentStatus = $Content.deploymentStatus
        DeploymentMessage = $Content.deploymentMessage
        DeploymentTargetVersion = $Content.deploymentTargetVersion
        DeploymentRunningVersion = $Content.deploymentRunningVersion
        DeploymentPreVersion = $Content.deploymentPreVersion
        LastDeploymentTime = (ConvertFrom-EpochMillisec -Value $Content.lastDeploymentTime)
        SerialNumber = $Content.serialNumber
        InstallType = $Content.installType
        AgentVersion = $Content.agentVersion
        PublicKey = $Content.publicKey
        Deleted = $Content.deleted
        QuarantineDesc = $Content.quarantineDesc
        LoginDomain = $Content.loginDomain
        AgentId = $Content.agentId
        AgentType = $Content.agentType
        ProfileVersion = $Content.profileVersion
        ProfileSerialNumber = $Content.profileSerialNo
        CreationDate = (ConvertFrom-EpochMillisec -Value $Content.creationTime)
        OnlineStatus = $Content.onlineStatus
        LastUpdateTime = (ConvertFrom-EpochMillisec -Value $Content.lastUpdateTime)
        LastSEPManager = $Content.lastServerName
        LastSiteName = $Content.lastSiteName
        Infected = $Content.infected
        LastScanTime = (ConvertFrom-EpochMillisec -Value $Content.lastScanTime)
        LastVirusTime = (ConvertFrom-EpochMillisec -Value $Content.lastVirusTime)
        ContentUpdate = $Content.contentUpdate
        AVEngineStatus = $Content.avEngineOnOff
        FirewallStatus = $Content.firewallOnOff
        TamperStatus = $Content.tamperOnOff
        PTPStatus = $Content.ptpOnOff
        DAStatus = $Content.daOnOff
        ELAMStatus = $Content.elamOnOff
        VSICStatus = $Content.vsicStatus
        PEPStatus = $Content.pepOnOff
        RebootRequired = $Content.rebootRequired
        RebootReason = $Content.rebootReason
    }
    
    return $oDevice
}