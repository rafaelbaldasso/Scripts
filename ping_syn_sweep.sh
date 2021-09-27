#!/bin/bash

if [ "$1" == "" ]
then
    echo ""
    echo " > ICMP + SYN ping sweep"
    echo " > Usage: $0 IP-RANGE"
    echo " > Example: $0 192.168.0.1-254"
else
    echo ""
    echo " > Scanning..."

    ip="${1%.*}"
    full_range="${1##*.}"
    r_begins=$(echo $full_range | cut -d "-" -f1)
    r_ends="${1##*-}"

    for ips in $(seq $r_begins $r_ends)
    do
	ping -c 1 -W 1 $ip.$ips 2> /dev/null | grep "64 bytes" | cut -d " " -f4 | cut -d ":" -f1 >> /tmp/ping_scan.txt;
	hping3 -S -c 1 $ip.$ips 2> /dev/null | grep "flags=" | cut -d " " -f2 | cut -d " " -f1 | cut -d "=" -f2 >> /tmp/ping_scan.txt;
    done
    cat /tmp/ping_scan.txt | sort -t . -k 4,4n | uniq > $PWD/ping_scan.txt
    #rm -f /tmp/ping_scan.txt
    echo " > Scan completed. Results saved to a file at $PWD/ping_scan.txt."
fi
