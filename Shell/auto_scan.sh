#!/bin/bash

if [ "$1" == "" ]
then
	echo ""
	echo " [>] Usage: $0 TARGET"
else
	echo ""
	echo " [>] Scanning..."
	ports=$(nmap -p- --min-rate=1000 -T4 $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')
	nmap -Pn -A -p $ports $1 -v0 -oN nmap_$1
	echo ""
	echo " [>] Scan Finished. Results added to the file nmap_$1."
fi
