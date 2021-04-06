#!/bin/bash
if [ "$1" == "" ]
then
	echo ""
	echo " [#] Port Knocker (Internal) ~ by Kothmun"
    	echo ""
	echo " [>] Usage: $0 NETWORK"
	echo " [>] Example: $0 172.16.1.100"
	echo ""
	echo " [!] Requires 'hping3' to run - might need to use 'sudo'"
	echo " [!] Manually set the ports in the script"
	echo ""
else
	echo ""
	echo " [#] Port Knocker (Internal) ~ by Kothmun"
    	echo ""
	
	for ip in {1..254};
	do
	hping3 -S -s 1238 -p 13 -c 1 $1.$ip 2> /dev/null | 1> /dev/null;
	hping3 -S -s 2879 -p 37 -c 1 $1.$ip 2> /dev/null | 1> /dev/null;
	hping3 -S -s 2116 -p 30000 -c 1 $1.$ip 2> /dev/null | 1> /dev/null;
	hping3 -S -s 1863 -p 3000 -c 1 $1.$ip 2> /dev/null | 1> /dev/null;
	hping3 -S -s 1972 -p 1337 -c 1 $1.$ip 2> /dev/null | grep "flags=SA";
	hping3 -R -s 1972 -p 1337 -c 1 $1.$ip 2> /dev/null | 1> /dev/null;
	done
	echo ""
fi
