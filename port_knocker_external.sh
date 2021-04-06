#!/bin/bash

if [ "$1" == "" ]
then
	echo ""
	echo " [#] Port Knocker (External) ~ by Kothmun"
    	echo ""
	echo " [>] Usage: $0 IP"
	echo " [>] Example: $0 37.58.10.101"
	echo ""
	echo " [!] Requires 'hping3' to run - might need to use 'sudo'"
	echo " [!] Manually set the ports in the script"
	echo ""
else
	echo ""
	echo " [#] Port Knocker (External) ~ by Kothmun"
	echo ""
	hping3 -S -s 1238 -p 13 -c 1 $1
	hping3 -S -s 2879 -p 37 -c 1 $1
	hping3 -S -s 2116 -p 30000 -c 1 $1
	hping3 -S -s 1863 -p 3000 -c 1 $1
	hping3 -S -s 1972 -p 1337 -c 1 $1
	hping3 -R -s 1972 -p 1337 -c 1 $1
	echo ""
fi

