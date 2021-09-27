#!/bin/bash
# If needed, use dos2unix to convert the wordlist file!

if [ "$1" == "" ] || [ "$2" == "" ]
then
	echo ""
	echo " [#] Web Directories Finder"
	echo ""
	echo " [>] How to use: $0 SITE WORDLIST"
	echo " [>] Example: $0 site.com list.txt"
	echo ""
else
	echo ""
	echo " [#] Web Directories Finder"
	echo "" 

for dir in $(cat $2)
do
response=$(curl -s -H "User-Agent: WebTool" -o /dev/null -w "%{http_code}" $1/$dir/)
if [ $response == "200" ]
then
	echo " [+] Directory found: http://$1/$dir/"
fi
done
	echo ""
fi
