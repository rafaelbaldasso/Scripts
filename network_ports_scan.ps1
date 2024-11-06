param($subnet, $ports)
if (-not $subnet -or -not $ports) {
    echo ""
    echo " [#] Network Ports Scan"
    echo ""
    echo " [>] Usage: .\network_ports_scan.ps1 SUBNET PORTS"
    echo " [>] Example: .\network_ports_scan.ps1 192.168.0.0/24 80,443,445"
    echo ""
} else {
    $ipBase = ($subnet -replace "\.\d{1,3}/\d{1,2}$", "")
    $portList = $ports -split "," | ForEach-Object { $_.Trim() }
    echo ""
    echo " [#] Network Ports Scan"
    echo ""
    echo " [>] Target Subnet: $subnet"
    echo " [>] Ports: $ports"
    echo ""
    trap {
        break
    }
    foreach ($i in 1..254) {
        $targetIP = "$ipBase.$i"
        $openPorts = @()
        foreach ($port in $portList) {
            if (Test-NetConnection -ComputerName $targetIP -Port $port -WarningAction SilentlyContinue -InformationLevel Quiet) {
                $openPorts += $port
            }
        }
        if ($openPorts.Count -gt 0) {
            echo " [+] Host: $targetIP - Open Ports: $($openPorts -join ', ')"
        }
    }
    echo ""
}
