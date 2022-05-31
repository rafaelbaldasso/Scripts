#!/bin/bash

### Requirements
# Python3
# Assetfinder -> go install github.com/tomnomnom/assetfinder@latest
# Gobuster -> apt install gobuster
# Subfinder -> go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# Nmap -> apt install nmap
# Seclists -> apt install seclists
# httpx -> go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
# Waybackurls -> go install github.com/tomnomnom/waybackurls@latest
# Shcheck -> wget https://raw.githubusercontent.com/santoru/shcheck/master/shcheck.py

if [ "$1" == "" ]
then
    echo;echo "[>] Usage: $0 <target>"
    echo "[>] Example: $0 github.com"
else

    target=$1
    PATH=$PATH:/root/go/bin
    clear
    echo
    echo "[>] Menu"
    echo
    PS3='-> '
    options=("Security Headers" "Fingerprint" "Subdomains Enumeration" "Discovery" "TCP Ports Full Scan" "UDP Top Ports Scan" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Security Headers")
	        clear
	        c1=('python3 shcheck.py http://'$target'')
	        c2=('python3 shcheck.py https://'$target'')
	        echo;echo ">>> HTTP:";echo;echo "~ "$c1;echo
	        $c1 | egrep "Missing|unreachable" | cut -d '(' -f1
	        echo;echo ">>> HTTPS:";echo;echo "~ "$c2;echo
	        $c2 | egrep "Missing|unreachable" | cut -d '(' -f1
	        echo
	        read -p "Press ENTER to continue"
	        exec $0 $1
	        ;;
            "Fingerprint")
	        clear
                echo;echo ">>> Scanning..."
	        c1=('httpx -silent -status-code -web-server -no-fallback -follow-redirects -no-color')
	        echo $target | $c1 >> /tmp/httpx.txt
                clear;echo;echo ">>> Fingerprint "$target"";echo;echo "~ "$c1;echo;
                cat /tmp/httpx.txt | sed 's/\[/\[HTTP /' | sed 's/\[\]/\[N\/A\]/'
	        echo
	        read -p "Press ENTER to continue"
	        rm -rf /tmp/httpx.txt
	        exec $0 $1
                ;;
            "Subdomains Enumeration")
	        clear
                echo;echo ">>> Scanning..."
                c1=('subfinder -d '$target' -silent')
	        c2=('assetfinder -subs-only '$target'')
	        $c1 > /tmp/subs.txt
	        $c2 >> /tmp/subs.txt
                sort -u /tmp/subs.txt > /tmp/subdomains.txt
                sed -i '/^'$target'/d' /tmp/subdomains.txt
	        c3=('httpx -silent -status-code -web-server -no-fallback -follow-redirects -no-color')
                cat /tmp/subdomains.txt | $c3 > /tmp/subs.txt
	        cat /tmp/subs.txt | sed 's/\[/\[HTTP /' | sed 's/\[\]/\[N\/A\]/' | grep -v "HTTP 404" > /tmp/subdomains.txt
                cat /tmp/subdomains.txt | sort -t/ -k 2 > /tmp/subs.txt
                clear;echo;echo ">>> Subdomains | Status | Web Server";echo;echo "~ "$c1;echo "~ "$c2;echo "~ "$c3;echo
	        cat /tmp/subs.txt;echo
                read -p "Press ENTER to continue"
	        rm -rf /tmp/subs.txt /tmp/subdomains.txt
                exec $0 $1
	        ;;
	    "Discovery")
	        clear
	        echo;echo ">>> Scanning..."
                c1=('gobuster dir -u '$target' -e -x txt --hide-length -t 10 --delay 100ms --wildcard --timeout 5s -z -q -w /usr/share/seclists/Discovery/Web-Content/common-and-portuguese.txt')
	        sudo $c1 | egrep "Status: 200|Status: 301" | cut -d ' ' -f1 | tr -d '\r' | sort -u >> /tmp/discovery.txt
                c2=('waybackurls -no-subs')
	        echo $target | $c2 >> /tmp/wayback.txt
                sed -i '/'$url'\/$/d' /tmp/wayback.txt
                cat /tmp/wayback.txt | egrep -v ".svg|.eot|.ttf|.woff|.css|.ico|.js|.gif|.jpg|.png|.jpeg" >> /tmp/discovery.txt
                clear;echo;echo ">>> Discovery of "$target"";echo;echo "~ "$c1;echo "~ "$c2;echo
                cat /tmp/discovery.txt | sort -u
	        echo
                read -p "Press ENTER to continue"
                rm -rf /tmp/wayback.txt /tmp/discovery.txt
	        exec $0 $1
	        ;;
	    "TCP Ports Full Scan")
	        clear
	        echo;echo ">>> Scanning..."
	        c1=('nmap -n -Pn -sSV -p- -T4 --open '$target'')
	        sudo $c1 >> /tmp/tcp.txt
                clear;echo;echo ">>> TCP Ports Full Scan";echo;echo "~ "$c1;echo
                cat /tmp/tcp.txt | head -n -3 | tail -n +2 | egrep "/tcp|Nmap|STATE";echo
	        read -p "Press ENTER to continue"
	        rm -rf /tmp/tcp.txt
	        exec $0 $1
	        ;;
	    "UDP Top Ports Scan")
	        clear
	        echo;echo ">>> Scanning..."
	        c1=('nmap -n -Pn -sUV -T4 --top-ports=20 --open '$target'')
	        sudo $c1 | grep -v "filtered" >> /tmp/udp.txt
                clear;echo;echo ">>> UDP Top Ports Scan";echo;echo "~ "$c1;echo;
                cat /tmp/udp.txt | head -n -3 | tail -n +2 | egrep "/udp|Nmap|STATE";echo
                read -p "Press ENTER to continue"
	        rm -rf /tmp/udp.txt
                exec $0 $1
	        ;;
            "Quit")
	        clear
                break
                ;;
            *) echo "Invalid option $REPLY!";;
        esac
    done
fi
