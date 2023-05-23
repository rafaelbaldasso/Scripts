#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]
then
    echo ""
    echo " [#] Network Port Scan"
    echo ""
    echo " [>] Usage: $0 NETWORK PORT"
    echo " [>] Example: $0 172.16.1 80"
    echo ""
    echo " [!] Requires 'hping3' to run - might need to use 'sudo'"
    echo ""
else
    echo ""
    echo " [#] Network Port Scan"
    echo ""
	
	for ip in {1..14};
	do
	hping3 -S -p $2 -c 1 $1.$ip 2> /dev/null | grep "flags=SA" | cut -d " " -f 2 | cut -d "=" -f 2;
	done
	echo ""
fi
