# Get the HTML page that contains the IP address information
    $htmlresponse = Invoke-WebRequest -Uri "http://www.ipchicken.com/" -UseBasicParsing

    # IP Address
        $IPAddress = ([regex]'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b').Matches($htmlresponse.content).value

    # Remote host
        $RemoteHost = ([regex]'Name\s+Address:\s+(.+?)<').Matches($htmlresponse.content).Groups[1].value.trim()

    # Remote Port
        $RemotePort = ([regex]'Remote\s+Port:\s+(.+?)<').Matches($htmlresponse.content).Groups[1].value.trim()

# Get information from the network adapter
    $WMInetwork = Get-WmiObject -Class "Win32_NetworkAdapterConfiguration" | where {$_.DefaultIPGateway} # This returns a list of network adapters, and selects the one that has a gateway

    $InternalIPAddress = $WMInetwork.IPAddress
    $HostName = $WMInetwork.DNSHostName
    $Domain = $WMInetwork.DNSDomainSuffixSearchOrder
    $DefaultGateway = $WMInetwork.DefaultIPGateway
    $DHCPENabled = $WMInetwork.DHCPEnabled
    $DHCPServer = $WMInetwork.DHCPServer
    $DNSServer = $WMInetwork.DNSServerSearchOrder
    $MACAddress = $WMInetwork.MACAddress


# Create output object
    $OutputObject = New-Object System.Object
    $OutputObject | Add-Member -type NoteProperty -name Public IP -value $IPAddress
    $OutputObject | Add-Member -type NoteProperty -name RemoteHost -value $RemoteHost
    $OutputObject | Add-Member -type NoteProperty -name Private IP -value $InternalIPAddress
    $OutputObject | Add-Member -type NoteProperty -name HostName -value $HostName
    $OutputObject | Add-Member -type NoteProperty -name Domain -value $Domain
    $OutputObject | Add-Member -type NoteProperty -name DefaultGateway -value $DefaultGateway
    $OutputObject | Add-Member -type NoteProperty -name DHCP -value $DHCPENabled
    $OutputObject | Add-Member -type NoteProperty -name DHCPServer -value $DHCPServer
    $OutputObject | Add-Member -type NoteProperty -name DNS -value $DNSServer
    $OutputObject | Add-Member -type NoteProperty -name MAC -value $MACAddress

# Output the output object
    $OutputObject
