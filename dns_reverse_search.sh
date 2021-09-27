#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]
then
	echo ""
	echo " [#] DNS Reverse Search"
	echo ""
	echo " [>] Usage: $0 BASE_IP IP_START IP_END"
	echo " [>] Example: $0 37.58.103 110 254"
	echo ""
else
	echo ""
	echo " [#] DNS Reverse Search"
	echo ""
	
	for ip in $(seq $2 $3);
	do
	host -t ptr $1.$ip | grep -v "ip$ip";
	done 
	echo ""
fi 
