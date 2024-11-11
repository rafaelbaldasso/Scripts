param($net)
if (!$net) {
    Write-Output "`n [#] Ping Sweep"
    Write-Output "`n [>] Usage: .\ping_sweep.ps1 NETWORK"
    Write-Output " [>] Example: .\ping_sweep.ps1 172.16.1`n"
} else {
    Write-Output "`n [#] Ping Sweep"
    Write-Output "`n [>] Network: $net.0"
    Write-Output "`n [>] IPs:"
foreach ($ip in 1..254) {
try {$resp = ping -n 1 -w 300 "$net.$ip" | Select-String "bytes=32"
$ips = $resp.Line.split(' ')[2] -replace ":",""
echo " [+] $ips"
} catch {}
}
Write-Output ""
}
