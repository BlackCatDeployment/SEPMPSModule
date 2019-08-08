<#
.Synopsis
    Test connection with a computer
.DESCRIPTION
    Test connection with a computer
.PARAMETER Computer
    Computer name to test
.PARAMETER Protocol
    Computer protocol to test
.PARAMETER Port
    Computer port to test
.PARAMETER ExitOnError
    Returns an error if the computer is not reachable
.PARAMETER ExitOnWarning
    Returns a warning if the computer is not reachable
.EXAMPLE
    Test-Port -Computer "wks01" -Port 3389
.EXAMPLE
    Test-Port -Computer "wks01" -Port 3389 -ExitOnError
.OUTPUT
    True is the port is opened
    False if the port is not opened
#>
Function Test-Port {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipeline=$true)][String] $Computer = $env:COMPUTERNAME,
        [Parameter(Mandatory=$false,ValueFromPipeline=$true)][ValidateSet("TCP","UDP")] $Protocol = "TCP",
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)] $Port,
        [Parameter(Mandatory=$false,ValueFromPipeline=$true)] [Switch] $ExitOnError,
        [Parameter(Mandatory=$false,ValueFromPipeline=$true)] [Switch] $ExitOnWarning
    )


    $PortList = $Port -split ","
    $PortOpened = $false

    ForEach ($prt in $PortList) {
        If ($Protocol -eq "UDP") {
            # Create a Net.Sockets.UdpClient object to use for
            # checking for open UDP ports.
            $Socket = New-Object Net.Sockets.UdpClient
        }
        Else {
            # Create a Net.Sockets.TcpClient object to use for
            # checking for open TCP ports.
            $Socket = New-Object Net.Sockets.TcpClient
        }
        
        # Try to connect
        try {
            $Socket.Connect($Computer, $prt)
        }
        catch {} #Mandatory to avoid exception if port is not opened
        
        # Determine if we are connected.
        If ($Socket.Connected) {           
            Write-Host "[Test-Port] ${Computer}: Port $Protocol $prt is open"
            $Socket.Close()
            $PortOpened = $true
        }
        Else {
            If ($ExitOnError) {
                Write-Error "[Test-Port] ${Computer}: Port $Protocol $prt is closed or filtered"
            }
            ElseIf ($ExitOnWarning) {
                Write-Warning "[Test-Port] ${Computer}: Port $Protocol $prt is closed or filtered"
                $PortOpened = $false
            }
            Else {
                Write-Host "[Test-Port] ${Computer}: Port $Protocol $prt is closed or filtered"
                $PortOpened = $false
            }
        }
        
        $Socket = $null
    }

    return $PortOpened
}
