#!/bin/bash                                                                                                                                                                            [2/305]
                                                                                                                                                                                              
if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ] || [ "$4" == "" ]                                                                                                                       
then
    echo ""
    echo " [>] Usage: $0 <target> <wordlist> <delay (in ms)> <recursion (y=yes/n=no)> <optional:extensions>"
    echo " [>] Example 1: $0 http://site.com/ list.txt 100 n .pdf,.txt"
    echo " [>] Example 2: $0 http://site.com/ list.txt 0 y"
else
    if [ "$5" == "" ]
    then
        if [ "$4" == "n" ] || [ "$4" == "N" ]
        then
            dirb $1 $2 -w -z $3 -r
        elif [ "$4" == "y" ] || [ "$4" == "Y" ] 
        then
            dirb $1 $2 -w -z $3
        else
            echo ""
            echo " [>] Wrong parameters!"
            exit 1
        fi
    else
        if [ "$4" == "n" ] || [ "$4" == "N" ]
        then
            dirb $1 $2 -w -z $3 -X $5 -r
        elif [ "$4" == "y" ] || [ "$4" == "Y" ] 
        then
            dirb $1 $2 -w -z $3 -X $5
        else
            echo ""
            echo " [>] Wrong parameters!"
            exit 1
        fi
    fi
fi
