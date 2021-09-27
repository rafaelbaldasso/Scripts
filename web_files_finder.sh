#!/bin/bash
# If needed, use dos2unix to convert the wordlist file!

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]
then
	echo ""
	echo " [#] Web Files Finder"
	echo ""
	echo " [>] Usage: $0 SITE FILENAMES_LIST EXTENSIONS_LIST"
	echo " [>] Example: $0 site.com files.txt ext.txt"
	echo ""
else
	echo ""
	echo " [#] Web Files Finder"
	echo ""

for file in $(cat $2)
do
	for ext in $(cat $3)
	do
	response=$(curl -s -H "User-Agent: WebTool" -o /dev/null -w "%{http_code}" $1/$file.$ext)
	if [ $response == "200" ]
	then
		echo " [+] File found: http://$1/$file.$ext"
	fi
	done
done
	echo ""
fi
