param($target)
if(!$target) {
    echo ""
    echo " [#] Port Scan"   
    echo ""
    echo " [>] Usage: .\port_scan.ps1 HOST"
    echo " [>] Example: .\port_scan.ps1 172.16.1.100"
    echo ""
} else {
    echo ""
    echo " [#] Port Scan"
    echo ""
    echo " [>] Target: $target"
    echo ""
    echo " [>] Open Ports:"
try {foreach ($port in 1..65535) {
if (Test-NetConnection $target -Port $port -WarningAction SilentlyContinue -InformationLevel Quiet) {
    echo " [+] $port"
}}
} catch {}
echo ""
}
