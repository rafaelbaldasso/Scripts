#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]
then
        echo ""
        echo " [#] Google Dorking Files"
        echo ""
        echo " [>] Usage: $0 SITE WORDLIST"
        echo " [>] Example: $0 site.com extensions_list.txt"
        echo ""
        echo " [!] Requires 'lynx' to run (sudo apt install lynx)"
else
        echo ""
        echo " [#] Google Dorking Files"
        echo ""
        echo " [>] Results:"
        echo ""

        for extension in $(cat $2);
        do
                lynx --dump "https://google.com/search?q=site%3A$1+ext%3A$extension" | grep "http" | sed 's/https:\/\/www.google.com\/url?q=//' | egrep -v "site|google|search?" | sed 's/^......//' | cut -d "&" -f1;
        done
fi
