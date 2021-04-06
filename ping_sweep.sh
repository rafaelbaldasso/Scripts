#!/bin/bash

if [ "$1" == "" ]
then
    echo ""
    echo " [#] Ping Sweep ~ by Kothmun"
	echo ""
    echo " [>] Usage: $0 NETWORK"
    echo " [>] Example: $0 192.168.1"
    echo ""
else
    echo ""
    echo " [#] Ping Sweep ~ by Kothmun"
    echo ""
	echo " [+] IPs:"

	for host in {1..254};
	do
	ping -c 1 $1.$host | grep "64 bytes" | cut -d " " -f 4 | sed 's/.$//';
	done
	echo ""
fi 