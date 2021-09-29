#!/bin/bash

if [ "$1" == "" ]
then
    echo ""
    echo " > ICMP + SYN ping sweep"
    echo " > Usage: $0 IP-RANGE"
    echo " > Example: $0 192.168.0.1-254"
else
    echo ""
    echo " > Processing..."
    echo ""
    
    ip="${1%.*}"
    full_range="${1##*.}"
    r_begins=$(echo $full_range | cut -d "-" -f1)
    r_ends="${1##*-}"

    for ips in $(seq $r_begins $r_ends)
    do
	ping -c 1 -W 1 $ip.$ips 2> /dev/null | grep "64 bytes" | cut -d " " -f4 | cut -d ":" -f1 >> /tmp/ping_sweep.txt;
	hping3 -S -c 1 $ip.$ips 2> /dev/null | grep "flags=" | cut -d " " -f2 | cut -d " " -f1 | cut -d "=" -f2 >> /tmp/ping_sweep.txt;
    	echo -en " > Current IP: $ip.$ips\r"
    done
    cat /tmp/ping_sweep.txt | sort -t . -k 4,4n | uniq > $PWD/ping_sweep.txt
    rm -f /tmp/ping_sweep.txt
    echo " > Completed. Results saved to a file at $PWD/ping_sweep.txt"
fi
