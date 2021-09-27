echo ""
echo " [#] Web Server Recon"
echo ""
$site = Read-Host " [>] Target"
$web = Invoke-WebRequest -uri "$site" -Method Options
echo ""
echo " [+] Web server: "
echo ""
$web.headers.server
echo ""
echo " [+] Accepted methods:"
echo ""
$web.headers.allow
echo ""
echo " [+] Links found:"
$web2 = Invoke-WebRequest -uri "$site"
$web2.links.href| Select-String "http"
