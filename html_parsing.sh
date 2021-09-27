#!/bin/bash

if [ "$1" == "" ]
then
    echo ""
    echo " [#] HTML Parsing"
	echo ""
    echo " [>] Usage: $0 SITE"
    echo " [>] Example: $0 www.site.com"
    echo ""
else
    echo ""
    echo " [#] HTML Parsing"
	echo ""
    echo " [>] Resolving the URLs from $1"
	echo ""

wget -O /tmp/index.html -q $1
grep href /tmp/index.html | cut -d "/" -f 3 | grep "\." | cut -d '"' -f 1 | grep -v "<l" > /tmp/urlslist.txt

for url in $(cat /tmp/urlslist.txt);
do
host $url | grep "has address" | awk -F' ' -v OFS="\t" '{print "",$4,"",$1}' >> /tmp/hostslist.txt;
done

        echo ""
        echo " ============================================================================="
        echo " |   #               IP                          URL                         |"
        echo " ============================================================================="
        cat /tmp/hostslist.txt | sort -n | uniq | cat -n
        echo " ============================================================================="
        echo ""

rm /tmp/index.html /tmp/urlslist.txt /tmp/hostslist.txt
fi
