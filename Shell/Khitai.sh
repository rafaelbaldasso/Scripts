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

clear
echo -e "\033[38;2;220;20;60m
                  .
                  |
             .   ]#[   .
              \_______/
           .    ]###[    .
            \___________/             _  __  _       _   _             _
         .     ]#####[     .         | |/ / | |     (_) | |           (_)
          \_______________/          | ' /  | |__    _  | |_    __ _   _
       .      ]#######[      .       |  <   |  _ \  | | | __|  / _  | | |
        \___]##.-----.##[___/        | . \  | | | | | | | |_  | (_| | | |
         |_|_|_|     |_|_|_|         |_|\_\ |_| |_| |_|  \__|  \__ _| |_|
         |_|_|_|_____|_|_|_|
       #######################
\033[m"

if [ "$1" == "" ]
then
    echo;echo -e "\033[38;2;255;228;181m[>] Usage: $0 <target>\033[m"
    echo -e "\033[38;2;255;228;181m[>] Example: $0 github.com\033[m";echo
else
    target=$1
    PATH=$PATH:/root/go/bin
    bold=$(tput bold)
    echo
    PS3='-> '
    options=("Security Headers" "Fingerprint Web Server" "SSL Scans" "Subdomains Enumeration" "Discovery" "TCP Ports Scan" "UDP Top Ports Scan" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Security Headers")
	        clear
	        c1=('python3 shcheck.py http://'$target'')
	        c2=('python3 shcheck.py https://'$target'')
	        echo;echo -e "\033[38;2;220;20;60m${bold}>>> HTTP:\033[m";echo;echo -e "\033[38;2;0;255;255m~ "$c1"\033[m";echo
	        sudo $c1 | egrep "Analyzing headers|Effective URL|Missing|unreachable" | cut -d '(' -f1
	        echo;echo -e "\033[38;2;220;20;60m${bold}>>> HTTPS:\033[m";echo;echo -e "\033[38;2;0;255;255m~ "$c2"\033[m";echo
	        sudo $c2 | egrep "Analyzing headers|Effective URL|Missing|unreachable" | cut -d '(' -f1
	        echo
	        read -p $'\033[38;2;255;215;0m<Press ENTER to continue>\033[m'
	        exec $0 $1
	        ;;
            "Fingerprint Web Server")
	        clear
                echo;echo -e "\033[38;2;0;255;0m>>> Scanning...\033[m"
	        c1=('httpx -silent -status-code -web-server -no-fallback -no-color')
	        echo $target | $c1 >> /tmp/httpx.txt
                clear;echo;echo -e "\033[38;2;220;20;60m${bold}>>> Fingerprint Web Server\033[m";echo;echo -e "\033[38;2;0;255;255m~ echo "$target" | "$c1"\033[m";echo;
                cat /tmp/httpx.txt | sed 's/\[/\[HTTP /' | sed 's/\[\]/\[N\/A\]/'
	        echo
	        read -p $'\033[38;2;255;215;0m<Press ENTER to continue>\033[m'
	        rm -rf /tmp/httpx.txt
	        exec $0 $1
                ;;
	    "SSL Scans")
		clear
		echo;echo -e "\033[38;2;0;255;0m>>> Scanning...\033[m"
		c1=('sslscan '$target'')
		echo -e "\033[38;2;220;20;60m${bold}>>> SSL Scans\033[m" > /tmp/ssl.txt;echo >> /tmp/ssl.txt;echo -e "\033[38;2;0;255;255m~ "$c1"\033[m" >> /tmp/ssl.txt;echo >> /tmp/ssl.txt
		sudo $c1 | tail -n +8 >> /tmp/ssl.txt
		clear
		less /tmp/ssl.txt
		rm -rf /tmp/ssl.txt
		exec $0 $1
		;;
            "Subdomains Enumeration")
	        clear
                echo;echo -e "\033[38;2;0;255;0m>>> Scanning...\033[m"
                c1=('subfinder -d '$target' -silent')
	        c2=('assetfinder -subs-only '$target'')
	        $c1 > /tmp/subs.txt
	        $c2 >> /tmp/subs.txt
                sort -u /tmp/subs.txt > /tmp/subdomains.txt
                sed -i '/^'$target'/d' /tmp/subdomains.txt
	        c3=('httpx -silent -status-code -web-server -no-fallback -no-color')
                cat /tmp/subdomains.txt | $c3 > /tmp/subs.txt
	        cat /tmp/subs.txt | sed 's/\[/\[HTTP /' | sed 's/\[\]/\[N\/A\]/' | grep -v "HTTP 404" > /tmp/subdomains.txt
                cat /tmp/subdomains.txt | sort -t/ -k 2 > /tmp/subs.txt
                clear;echo;echo -e "\033[38;2;220;20;60m${bold}>>> Subdomains | Status | Web Server\033[m";echo;echo -e "\033[38;2;0;255;255m~ "$c1"\033[m";echo -e "\033[38;2;0;255;255m~ "$c2"\033[m";echo -e "\033[38;2;0;255;255m~ cat subdomains | "$c3"\033[m";echo
	        cat /tmp/subs.txt;echo
                read -p $'\033[38;2;255;215;0m<Press ENTER to continue>\033[m'
	        rm -rf /tmp/subs.txt /tmp/subdomains.txt
                exec $0 $1
	        ;;
	    "Discovery")
	        clear
	        echo;echo -e "\033[38;2;0;255;0m>>> Scanning...\033[m"
                c1=('gobuster dir -u '$target' -e -x txt,pdf --hide-length -t 2 --delay 100ms --wildcard --timeout 5s -z -q -w /usr/share/seclists/Discovery/Web-Content/common-and-portuguese.txt')
	        sudo $c1 | egrep "Status: 200|Status: 301" | cut -d ' ' -f1 | tr -d '\r' | sort -u >> /tmp/discovery.txt
                c2=('waybackurls -no-subs')
	        echo $target | $c2 >> /tmp/wayback.txt
                sed -i '/'$url'\/$/d' /tmp/wayback.txt
                cat /tmp/wayback.txt | egrep -v ".svg|.eot|.ttf|.woff|.css|.ico|.js|.gif|.jpg|.png|.jpeg" >> /tmp/discovery.txt
                clear;echo;echo -e "\033[38;2;220;20;60m${bold}>>> Discovery\033[m";echo;echo -e "\033[38;2;0;255;255m~ "$c1"\033[m";echo -e "\033[38;2;0;255;255m~ echo "$target" | "$c2"\033[m";echo
                cat /tmp/discovery.txt | sort -u
	        echo
                read -p $'\033[38;2;255;215;0m<Press ENTER to continue>\033[m'
                rm -rf /tmp/wayback.txt /tmp/discovery.txt
	        exec $0 $1
	        ;;
	    "TCP Ports Scan")
	        clear
	        echo;echo -e "\033[38;2;0;255;0m>>> Scanning...\033[m"
	        c1=('nmap -n -Pn -sSV -p- -T4 --open '$target'')
	        sudo $c1 >> /tmp/tcp.txt
                clear;echo;echo -e "\033[38;2;220;20;60m${bold}>>> TCP Ports Scan\033[m";echo;echo -e "\033[38;2;0;255;255m~ "$c1"\033[m";echo
                cat /tmp/tcp.txt | head -n -3 | tail -n +2 | egrep "/tcp|Nmap|STATE";echo
	        read -p $'\033[38;2;255;215;0m<Press ENTER to continue>\033[m'
	        rm -rf /tmp/tcp.txt
	        exec $0 $1
	        ;;
	    "UDP Top Ports Scan")
	        clear
	        echo;echo -e "\033[38;2;0;255;0m>>> Scanning...\033[m"
	        c1=('nmap -n -Pn -sUV -T4 --top-ports=20 --open '$target'')
	        sudo $c1 | grep -v "filtered" >> /tmp/udp.txt
                clear;echo;echo -e "\033[38;2;220;20;60m${bold}>>> UDP Top Ports Scan\033[m";echo;echo -e "\033[38;2;0;255;255m~ "$c1"\033[m";echo;
                cat /tmp/udp.txt | head -n -3 | tail -n +2 | egrep "/udp|Nmap|STATE";echo
                read -p $'\033[38;2;255;215;0m<Press ENTER to continue>\033[m'
	        rm -rf /tmp/udp.txt
                exec $0 $1
	        ;;
            "Quit")
	        clear
                break
                ;;
            *) exec $0 $1;;
        esac
    done
fi
