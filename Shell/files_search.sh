#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]
then
        echo ""
        echo " [#] Files Search"
        echo ""
        echo " [>] Usage: $0 SITE EXTENSION"
        echo " [>] Example: $0 site.com pdf"
        echo ""
        echo " [!] Requires 'lynx' to run"
        echo ""
else
        echo ""
        echo " [#] Files Search"
        echo ""
        echo " [>] URLs:"
        echo ""

lynx --dump "https://google.com/search?&q=site:$1+ext:$2" | grep ".$2" | grep "http" |cut -d "=" -f2 | egrep -v "site|google|search?" | sed 's/...$//'
echo ""
fi
