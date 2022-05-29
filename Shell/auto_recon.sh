#!/bin/bash

### Requirements
# Python3
# Assetfinder -> go install github.com/tomnomnom/assetfinder@latest
# Gobuster -> apt install gobuster
# Subfinder -> go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# Sublist3r -> apt install sublist3r
# Nmap -> apt install nmap
# Seclists -> apt install seclists
# httpx -> go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
# Waybackurls -> go install github.com/tomnomnom/waybackurls@latest
# Shcheck -> wget https://raw.githubusercontent.com/santoru/shcheck/master/shcheck.py

if [ "$1" == "" ]
then
        echo ""
        echo " [>] Usage: sudo $0 <target> <d = domain mode>"
	echo " [>] Example domain: sudo $0 github.com -d"
	echo " [>] Example subdomain: sudo $0 desktop.github.com"
	echo ""
else
        url=$1
	echo ""

	if [ "$2" == "-d" ] || [ "$2" == "-D" ]
	then

	        target=`echo $url | cut -d '.' -f 1`
	        mkdir $target
	        
	else
		dom=`echo $url | cut -d '.' -f 2`
		sub=`echo $url | cut -d '.' -f 1`
		target=$sub.$dom
		rm -rf $target
		mkdir $target
	fi

# Validating the target and grabbing the banner

	echo " [>] Validating the target..."

	echo $url | httpx -silent -status-code -web-server -no-fallback -follow-redirects -no-color >> $target/httpx.txt
	echo "" > recon-$target.txt;echo ">>>> Target | Status | Web Server" >> recon-$target.txt;echo "" >> recon-$target.txt;
	cat $target/httpx.txt | sed 's/\[/\[HTTP /' | sed 's/\[\]/\[N\/A\]/' >> recon-$target.txt
	
# Subdomains discovery

	if [ "$2" == "-d" ] || [ "$2" == "-D" ]
	then
        	echo " [>] Scanning the subdomains..."

	        subfinder -d $url -silent >> $target/subs.txt
	        
#	        sublist3r -d $url -n >> $target/sublist3r.txt
#        	sed -i '/ '$url'/d' $target/sublist3r.txt
#        	cat $target/sublist3r.txt | grep $url | grep -v virustotal >> $target/subs.txt        	

        	assetfinder -subs-only $url >> $target/subs.txt

        	sort -u $target/subs.txt >> $target/subdomains.txt
        	sed -i '/^'$url'/d' $target/subdomains.txt

	# Validating subdomains and grabbing the webserver banner

		cat $target/subdomains.txt | httpx -silent -status-code -web-server -no-fallback -follow-redirects -no-color >> $target/valid-subdomains.txt
		cat $target/valid-subdomains.txt | sed 's/\[/\[HTTP /' | sed 's/\[\]/\[N\/A\]/' | grep -v "HTTP 404" >> $target/valid-subdomains-regex.txt
		cat $target/valid-subdomains-regex.txt | sort -t/ -k 2 > $target/subdomains.txt

	        echo "" >> recon-$target.txt;echo "" >> recon-$target.txt;echo ">>>> Subdomains | Status | Web Server" >> recon-$target.txt;echo "" >> recon-$target.txt;
		cat $target/subdomains.txt >> recon-$target.txt;
	fi
	
# Checking the security headers

	http="http://"
	python3 shcheck.py $http$url --colours=none >> $target/shcheck-http.txt
	cat $target/shcheck-http.txt | grep Missing | cut -d ":" -f2 | sed 's/ //' >> $target/headers-http.txt
	echo "" >> recon-$target.txt;echo "" >> recon-$target.txt;echo ">>>> Missing security Headers (HTTP)" >> recon-$target.txt;echo "" >> recon-$target.txt;
	cat $target/headers-http.txt >> recon-$target.txt
	cat $target/shcheck-http.txt | grep unreachable | cut -d "(" -f1 >> recon-$target.txt
	
	https="https://"
	python3 shcheck.py $https$url --colours=none >> $target/shcheck-https.txt
	cat $target/shcheck-https.txt | grep Missing | cut -d ":" -f2 | sed 's/ //' >> $target/headers-https.txt
	echo "" >> recon-$target.txt;echo "" >> recon-$target.txt;echo ">>>> Missing security Headers (HTTPS)" >> recon-$target.txt;echo "" >> recon-$target.txt;
	cat $target/headers-https.txt >> recon-$target.txt
	cat $target/shcheck-https.txt | grep unreachable | cut -d "(" -f1 >> recon-$target.txt

# Directories/files discovery

        echo " [>] Scanning directories and files..."

        gobuster dir -u $url -e -x txt --hide-length -t 10 --delay 100ms --wildcard --timeout 5s -z -q -w /usr/share/seclists/Discovery/Web-Content/common-and-portuguese.txt >> $target/go-discover.txt
        cat $target/go-discover.txt | egrep "Status: 200|Status: 301" | cut -d ' ' -f1 | tr -d '\r' | sort -u >> $target/discovery.txt
        
        echo $url | waybackurls -no-subs >> $target/way-discovery.txt
        sed -i '/'$url'\/$/d' $target/way-discovery.txt
        cat $target/way-discovery.txt | egrep -v ".svg|.eot|.ttf|.woff|.css|.ico|.js|.gif|.jpg|.png|.jpeg" >> $target/discovery.txt
        echo "" >> recon-$target.txt;echo "" >> recon-$target.txt;echo ">>>> Directories/files" >> recon-$target.txt;echo "" >> recon-$target.txt
        cat $target/discovery.txt | sort -u >> recon-$target.txt


# TCP ports scan

        echo " [>] Scanning ports..."

        sudo nmap -n -Pn -sS -T4 -p- --open -v0 $url -oN $target/ports.txt

        for item in $(cat $target/ports.txt | grep "/tcp" | cut -d '/' -f 1);do
                list=$list,$item
        done
        ports=$(echo $list | sed 's/^.//')
        sudo nmap -n -Pn -sSV -sC -O -p $ports $url -v0 -oN $target/tcp-scan.txt
        
        echo "" >> recon-$target.txt;echo "" >> recon-$target.txt;echo ">>>> TCP scan" >> recon-$target.txt;echo "" >> recon-$target.txt;
        cat $target/tcp-scan.txt | head -n -3 | tail -n +2 >> recon-$target.txt

# UDP ports scan

        sudo nmap -n -Pn -sUV --top-ports=20 --open -sC -v0 $url -oN $target/udp-scan-grep.txt
        cat $target/udp-scan-grep.txt | grep -v "filtered" >> $target/udp-scan.txt
        
        echo "" >> recon-$target.txt;echo "" >> recon-$target.txt;echo ">>>> UDP scan" >> recon-$target.txt;echo "" >> recon-$target.txt;
        cat $target/udp-scan.txt | head -n -3 | tail -n +2 >> recon-$target.txt

# Finishing the process

	echo "" >> recon-$target.txt
        rm -rf $target

        echo ""
        echo " [>] Scan completed. Results are available at '$(pwd)/recon-$target.txt'"
	echo ""
fi
