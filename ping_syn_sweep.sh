#!/bin/bash

if [ "$1" == "" ]
then
    echo ""
    echo " [#] Network Scanner ~ by Kothmun"
    echo " [>] ICMP + SYN 'ping' sweep"
    echo " [!] This tool requires 'hping3' to run, thus it might also need 'sudo' [!]"
    echo ""
    echo " [>] How to use: $0 NETWORK"
    echo " [>] Example: $0 10.10.3"
    echo " [>] Example: $0 172.16"
    echo ""
else
    echo ""
    echo " [>] Scanning..."
    echo " [>] The results will be saved as net_scan.txt in the current directory."

    net="${1//[^.]}"
    network="${#net}"

    if [ "$network" == "2" ]
    then
        for ip in {1..14}
        do
            hping3 -S $1.$ip -c 1 2> /dev/null | grep "flags=" | cut -d " " -f2 >
            ping $1.$ip -c 1 -W 1 2> /dev/null | grep "64 bytes" | cut -d " " -f>
        done
    elif [ "$network" == "1" ]
    then
        for ip2 in {0..254}
        do
            for ip1 in {1..254}
            do
                hping3 -S $1.$ip2.$ip1 -c 1 2> /dev/null | grep "flags" | cut -d>
                ping $1.$ip2.$ip1 -c 1 -W 1 2> /dev/null | grep "64 bytes" | cut>
            done
        done
    elif [ "$network" == "0" ]
    then
        for ip3 in {0..254}
        do
            for ip2 in {0..254}
            do
                for ip1 in {1..254}
                do
                    hping3 -S $1.$ip3.$ip2.$ip1 -c 1 2> /dev/null | grep "flags">
                    ping $1.$ip3.$ip2.$ip1 -c 1 -W 1 2> /dev/null | grep "64 byt>
                done
            done
        done
    else
        echo ""
        echo " [!] Incorrect parameters [!]"
        echo ""
        exit 1
    fi
    cat /tmp/results_hping.txt >> /tmp/results_ping.txt
    cat /tmp/results_ping.txt | sort -n | uniq >> ./net_scan.txt
    rm -f /tmp/results_hping.txt
    rm -f /tmp/results_ping.txt
    echo ""
    echo " [>] Scan completed!"
    echo ""
fi
