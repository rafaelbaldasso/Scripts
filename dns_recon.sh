#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]
then
	echo ""
	echo " [#] DNS Recon ~ by Kothmun"
	echo ""
	echo " [>] Usage: $0 SITE WORDLIST"
	echo " [>] Example: $0 site.com list.txt"
	echo ""
else	
	echo ""
	echo " [#] DNS Recon ~ by Kothmun"
	echo ""
	
	for word in $(cat $2);
	do
	host $word.$1 | grep -v "NXDOMAIN" | grep -v "IPv6";
	done
	echo ""
fi	
