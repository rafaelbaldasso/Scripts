#!/bin/bash

### Required Tools ###
# Assetfinder -> go install github.com/tomnomnom/assetfinder@latest
# Gobuster -> apt install gobuster
# Subfinder -> go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# Sublist3r -> apt install sublist3r
# OpenRDAP -> go install github.com/openrdap/rdap/cmd/rdap@latest
# Masscan -> apt install masscan
# Nmap -> apt install nmap
# Seclists -> apt install seclists

if [ "$1" == "" ]
then
        echo ""
        echo " [>] Usage: sudo $0 <site>"
else
        target=$1
        domain=`echo $target | cut -d '.' -f 1`
        mkdir $domain

        echo ""
        echo " [>] Scanning subdomains..."

# Subdomains discovery

        subfinder -d $target -silent >> $domain/.temp-subfinder-$domain.txt
        sublist3r -d $target -n >> $domain/.temp-sublist3r-$domain.txt
        assetfinder -subs-only $target >> $domain/.temp-assetfinder-$domain.txt

# Creating a single file

        cat $domain/.temp-subfinder-$domain.txt >> $domain/.temp-subdomains-$domain.txt
        sed -i '/ '$target'/d' $domain/.temp-sublist3r-$domain.txt
        grep $target $domain/.temp-sublist3r-$domain.txt >> $domain/.temp-subdomains-$domain.txt
        cat $domain/.temp-assetfinder-$domain.txt >> $domain/.temp-subdomains-$domain.txt
        sort -u $domain/.temp-subdomains-$domain.txt >> $domain/subdomains-$domain.txt
        sed -i '/^'$target'/d' $domain/subdomains-$domain.txt

        echo " [>] Scanning ports..."

# Open TCP ports discovery

        query_nmap=('sudo nmap -n -Pn -sS -T4 -p- --open -v0 '$target' -oN '$domain'/.temp-nmap-'$domain'-ports.txt')
        $query_nmap

# TCP ports scan

        for item in $(cat $domain/.temp-nmap-$domain-ports.txt | grep "/tcp" | cut -d '/' -f 1)
        do
                list=$list,$item
        done
        ports=$(echo $list | sed 's/^.//')
        query_tcp='sudo nmap -n -Pn -sSV -sC -O -p '$ports' '$target' -v0 -oN '$domain'/tcp-portscan-'$domain'.txt'
        $query_tcp

# UDP ports scan

        query_udp=('sudo nmap -n -Pn -sUV --top-ports=20 --open -sC -v0 '$target' -oN '$domain'/.temp-udp-portscan-'$domain'.txt')
        $query_udp
        cat $domain/.temp-udp-portscan-$domain.txt | grep -v "filtered" >> $domain/udp-portscan-$domain.txt

        echo " [>] Scanning directories and files..."

# Gobuster directories/files discovery

        query_go=('gobuster dir -u '$target' -e -x pdf,txt --hide-length -r -t 10 --delay 100ms --exclude-length 0 --timeout 5s -z -q -w /usr/share/seclists/Discovery/Web-Content/common-and-portuguese.txt')
        $query_go >> $domain/.temp-discovery-$domain.txt
        grep "200" $domain/.temp-discovery-$domain.txt | sort -u >> $domain/discovery-$domain.txt

# Removing all unnecessary files

        rm -rf $domain/.temp-*

        echo ""
        echo " [>] Scan finished."
fi
