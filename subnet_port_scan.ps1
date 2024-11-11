param($subnet, $ports)

if (-not $subnet -or -not $ports) {
    Write-Output "`n [#] Subnet Port Scan"
    Write-Output "`n [>] Usage: .\subnet_port_scan.ps1 SUBNET PORTS"
    Write-Output " [>] Example: .\subnet_port_scan.ps1 192.168.15.0/24 80,443,445`n"
} else {
    $ip, $prefixLength = $subnet -split '/'
    $prefixLength = [int]$prefixLength

    $ipAddress = [System.Net.IPAddress]::Parse($ip)
    $ipBytes = $ipAddress.GetAddressBytes()
    [Array]::Reverse($ipBytes)
    $ipNumber = [BitConverter]::ToUInt32($ipBytes, 0)

    $subnetMask = [math]::Pow(2, 32) - [math]::Pow(2, 32 - $prefixLength)
    $networkAddress = $ipNumber -band [uint32]$subnetMask
    $broadcastAddress = $networkAddress + [uint32]([math]::Pow(2, 32 - $prefixLength) - 1)

    $networkIp = [System.Net.IPAddress]::new([BitConverter]::GetBytes([uint32]$networkAddress))
    $broadcastIp = [System.Net.IPAddress]::new([BitConverter]::GetBytes([uint32]$broadcastAddress))

    [Array]::Reverse($networkIp.GetAddressBytes())
    [Array]::Reverse($broadcastIp.GetAddressBytes())

    $startIp = [BitConverter]::ToUInt32($networkIp.GetAddressBytes(), 0) + 1
    $endIp = [BitConverter]::ToUInt32($broadcastIp.GetAddressBytes(), 0) - 1

    $calcSIpBytes = [BitConverter]::GetBytes([uint32]$startIp)
    [Array]::Reverse($calcSIpBytes)
    $startIpNum = [System.Net.IPAddress]::new($calcSIpBytes)

    $calcEIpBytes = [BitConverter]::GetBytes([uint32]$endIp)
    [Array]::Reverse($calcEIpBytes)
    $endIpNum = [System.Net.IPAddress]::new($calcEIpBytes)

    Write-Output "`n [#] Subnet Port Scan"
    Write-Output "`n [>] Target Subnet: $subnet"
    Write-Output " [>] IP Range: $startIpNum to $endIpNum"
    Write-Output " [>] Ports: $ports`n"


    $portList = $ports -split "," | ForEach-Object { $_.Trim() }

    trap {
        Write-Output "`n [!] Scan interrupted.`n"
        break
    }

    for ($ipNumber = $startIp; $ipNumber -le $endIp; $ipNumber++) {
        $currentIpBytes = [BitConverter]::GetBytes([uint32]$ipNumber)
        [Array]::Reverse($currentIpBytes)
        $targetIP = [System.Net.IPAddress]::new($currentIpBytes)

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

    Write-Output "`n [!] Scan completed.`n"
}
