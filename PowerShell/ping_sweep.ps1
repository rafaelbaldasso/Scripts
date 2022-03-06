param($net)
if (!$net) {
    echo ""
    echo " [#] Ping Sweep"
	echo ""
    echo " [>] Usage: .\ping_sweep.ps1 NETWORK"
    echo " [>] Example: .\ping_sweep.ps1 172.16.1.100"
    echo ""
} else {
    echo ""
    echo " [#] Ping Sweep"
    echo ""
    echo " [>] Network: $net.X"
    echo ""
    echo " [>] IPs:"
foreach ($ip in 1..254) {
try {$resp = ping -n 1 -w 300 "$net.$ip" | Select-String "bytes=32"
$ips = $resp.Line.split(' ')[2] -replace ":",""
echo " [+] $ips"
} catch {}
}
echo ""
}
