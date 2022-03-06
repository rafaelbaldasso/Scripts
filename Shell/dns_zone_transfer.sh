#!/bin/bash

if [ "$1" == "" ]
then
	echo ""
	echo " [#] DNS Zone Transfer"
	echo ""
	echo " [>] Usage: $0 HOST"
	echo " [>] Example: $0 site.com"
	echo ""
else
	echo ""
	echo " [#] DNS Zone Transfer"
	echo ""
	
	for server in $(host -t ns $1 | cut -d " " -f 4);
	do
	host -l -a $1 $server;
	done
	echo ""
fi 
