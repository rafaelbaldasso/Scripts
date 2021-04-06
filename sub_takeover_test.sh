#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]
then
	echo ""
	echo " [#] Subdomain Takeover Test ~ by Kothmun"
	echo ""
	echo " [>] Usage: $0 SITE WORDLIST"
	echo " [>] Example: $0 site.com list.txt"
	echo ""
else	
	echo ""
	echo " [#] Subdomain Takeover Test ~ by Kothmun"
	echo ""
	for word in $(cat $2);
	do
	host -t cname $word.$1 | grep "alias for";
	done
	echo ""
fi	
