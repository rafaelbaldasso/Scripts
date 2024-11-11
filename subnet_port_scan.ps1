param($subnet, $ports)
if (-not $subnet -or -not $ports) {
    Write-Output "`n [#] Subnet Port Scan"
    Write-Output "`n [>] Usage: .\subnet_port_scan.ps1 SUBNET PORTS"
    Write-Output " [>] Example: .\subnet_port_scan.ps1 192.168.0.0/24 80,443,445`n"
} else {
    $ipBase = ($subnet -replace "\.\d{1,3}/\d{1,2}$", "")
    $portList = $ports -split "," | ForEach-Object { $_.Trim() }
    Write-Output "`n [#] Subnet Port Scan"
    Write-Output "`n [>] Target Subnet: $subnet"
    Write-Output "`n [>] Ports: $ports`n"
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
            Write-Output " [+] Host: $targetIP - Open Ports: $($openPorts -join ', ')"
        }
    }
    Write-Output ""
}
