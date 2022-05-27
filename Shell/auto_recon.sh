#!/bin/bash

### Required Tools ###
# Assetfinder -> go install github.com/tomnomnom/assetfinder@latest
# Gobuster -> apt install gobuster
# Subfinder -> go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# Sublist3r -> apt install sublist3r
# Nmap -> apt install nmap
# Seclists -> apt install seclists
# httpx -> go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

if [ "$1" == "" ]
then
        echo ""
        echo " [>] Usage: sudo $0 <site> <d = domain mode>"
	echo " [>] Example domain: sudo $0 github.com d"
	echo " [>] Example subdomain: sudo $0 desktop.github.com"
	echo ""
else
        target=$1
	echo ""

# Subdomains discovery

	if [ "$2" == "d" ] || [ "$2" == "D" ]
	then

	        domain=`echo $target | cut -d '.' -f 1`
	        mkdir $domain

        	echo " [>] Scanning the subdomains..."

	        subfinder -d $target -silent >> $domain/.temp-subfinder-$domain.txt
        	sublist3r -d $target -n >> $domain/.temp-sublist3r-$domain.txt
        	assetfinder -subs-only $target >> $domain/.temp-assetfinder-$domain.txt

# Generating a single file

	        cat $domain/.temp-subfinder-$domain.txt >> $domain/.temp-subdomains-$domain.txt
        	sed -i '/ '$target'/d' $domain/.temp-sublist3r-$domain.txt
        	grep $target $domain/.temp-sublist3r-$domain.txt >> $domain/.temp-subdomains-$domain.txt
        	cat $domain/.temp-assetfinder-$domain.txt >> $domain/.temp-subdomains-$domain.txt
        	sort -u $domain/.temp-subdomains-$domain.txt >> $domain/.subdomains-$domain.txt
        	sed -i '/^'$target'/d' $domain/.subdomains-$domain.txt

# Validating subdomains and grabbing the webserver banner

		cat $domain/.subdomains-$domain.txt | httpx -silent -status-code -web-server -no-fallback -follow-redirects -no-color > $domain/.valid-subdomains-$domain.txt
		cat $domain/.valid-subdomains-$domain.txt | sed 's/\[/\[HTTP /' | sed 's/\[\]/\[N\/A\]/' > $domain/.valid2-subdomains-$domain.txt
		cat $domain/.valid2-subdomains-$domain.txt | sort -t/ -k 2 > $domain/subdomains-$domain.txt

	        echo "" > recon-$domain.txt;echo " >>> Subdomains | Status | Web Server" >> recon-$domain.txt;echo "" >> recon-$domain.txt;cat $domain/subdomains-$domain.txt >> recon-$domain.txt
		echo "" >> recon-$domain.txt
	else
		dom=`echo $target | cut -d '.' -f 2`
		sub=`echo $target | cut -d '.' -f 1`
		domain=$sub.$dom
		rm -rf $domain
		mkdir $domain

	fi

# Validating the target and grabbing the banner - creating the final fine

	echo " [>] Validating the target..."

	echo "" >> recon-$domain.txt;echo " >>> Domain | Status | Web Server" >> recon-$domain.txt;echo "" >> recon-$domain.txt;
	echo $target | httpx -silent -status-code -web-server -no-fallback -follow-redirects -no-color | sed 's/\[/\[HTTP /' | sed 's/\[\]/\[N\/A\]/' >> recon-$domain.txt

# Open TCP ports discovery

        echo " [>] Scanning ports..."

        query_nmap=('sudo nmap -n -Pn -sS -T4 -p- --open -v0 '$target' -oN '$domain'/.temp-nmap-'$domain'-ports.txt')
        $query_nmap

# TCP ports scan

        for item in $(cat $domain/.temp-nmap-$domain-ports.txt | grep "/tcp" | cut -d '/' -f 1);do
                list=$list,$item
        done
        ports=$(echo $list | sed 's/^.//')
        query_tcp='sudo nmap -n -Pn -sSV -sC -O -p '$ports' '$target' -v0 -oN '$domain'/tcp-portscan-'$domain'.txt'
        $query_tcp

# UDP ports scan

        query_udp=('sudo nmap -n -Pn -sUV --top-ports=20 --open -sC -v0 '$target' -oN '$domain'/.temp-udp-portscan-'$domain'.txt')
        $query_udp
        cat $domain/.temp-udp-portscan-$domain.txt | grep -v "filtered" >> $domain/udp-portscan-$domain.txt

# Gobuster directories/files discovery

        echo " [>] Scanning directories and files..."

        query_go=('gobuster dir -u '$target' -e -x txt --hide-length -r -t 10 --delay 100ms --exclude-length 0 --timeout 5s -z -q -w /usr/share/seclists/Discovery/Web-Content/common-and-portuguese.txt')
        $query_go >> $domain/.temp-discovery-$domain.txt
        cat $domain/.temp-discovery-$domain.txt | sort -u | sed 's/(Status:/\[HTTP/' | sed 's/)/\]/' | tr -d '\r' >> $domain/discovery-$domain.txt

# Generating the final file and removing the temporary ones

        echo "" >> recon-$domain.txt;echo "" >> recon-$domain.txt;echo " >>> Directories/files" >> recon-$domain.txt;echo "" >> recon-$domain.txt;cat $domain/discovery-$domain.txt >> recon-$domain.txt
        echo "" >> recon-$domain.txt;echo "" >> recon-$domain.txt;echo " >>> TCP scan" >> recon-$domain.txt;echo "" >> recon-$domain.txt;cat $domain/tcp-portscan-$domain.txt | head -n -3 | tail -n +2 >> recon-$domain.txt
        echo "" >> recon-$domain.txt;echo "" >> recon-$domain.txt;echo " >>> UDP scan" >> recon-$domain.txt;echo "" >> recon-$domain.txt;cat $domain/udp-portscan-$domain.txt | head -n -3 | tail -n +2 >> recon-$domain.txt;
	echo "" >> recon-$domain.txt
        rm -rf $domain

        echo ""
        echo " [>] Scan completed. Results are available at '$(pwd)/recon-$domain.txt'"
	echo ""
fi
