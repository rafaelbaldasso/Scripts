#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]
then
        echo ""
        echo -e " \033[38;2;0;255;0m[#] MetaXtract\033[m"
        echo ""
        echo -e " \033[38;2;0;255;0m[#] Extract metadata from the target's exposed files!\033[m"
	echo ""
        echo -e " \033[38;2;0;255;255m[>] Usage: $0 SITE EXTENSION\033[m"
        echo -e " \033[38;2;0;255;255m[>] Example: $0 site.com pdf\033[m"
        echo ""
        echo -e " \033[38;2;255;0;0m[!] Requires 'lynx' and 'exiftool' to run (sudo apt install lynx exiftool)\033[m"
else
        echo ""
        echo -e " \033[38;2;0;255;0m[#] MetaXtract\033[m"
        echo ""
	echo -e " \033[38;2;0;255;255m[>] Task: Extract metadata from $2 files at $1\033[m"

if [ -d "/tmp/metaxtract_data/" ]
then
	rm -rf /tmp/metaxtract_data
fi
mkdir /tmp/metaxtract_data

lynx --dump "https://google.com/search?&q=site:$1+ext:$2" | grep ".$2" | grep "http" | cut -d "=" -f2 | egrep -v "site|google|search?" | sed 's/...$//' > /tmp/metaxtract_data/metaxtract_urls.txt

if [ ! -s /tmp/metaxtract_data/metaxtract_urls.txt ]
then
	echo -e " \033[38;2;255;0;0m[!] No $2 file(s) found at $1\033[m"
	rm -rf /tmp/metaxtract_data
	exit
else
	echo ""
	echo -e " \033[38;2;255;255;0m[!] File(s) found:\033[m"
	for url in $(cat /tmp/metaxtract_data/metaxtract_urls.txt);
	do
		echo " [+] $url";
	done
fi
echo ""
echo -e " \033[38;2;255;0;0m[?] Download the file(s) and extract the metadata (y/n)?\033[m" 
read -p " [?]: " input1
if [ "$input1" != "y" ]
then
	rm -rf /tmp/metaxtract_data/
	echo ""
	echo -e " \033[38;2;255;0;0m[#] Exiting\033[m"
	exit
else	
	echo ""
	echo -e " \033[38;2;0;255;255m[>] Processing...\033[m"
	for url in $(cat /tmp/metaxtract_data/metaxtract_urls.txt);
	do
	wget -P /tmp/metaxtract_data/ -q $url;
	done
fi

rm -rf /tmp/metaxtract_data/metaxtract_urls.txt

exiftool /tmp/metaxtract_data/* >> ./MetaXtract_$2.txt
echo ""
echo -e " \033[38;2;255;255;0m[!] Metadata extracted to ./MetaXtract_$2.txt\033[m"
echo ""
echo -e " \033[38;2;255;0;0m[?] Keep the downloaded file(s) (y/n)?\033[m" 
read -p " [?]: " input2
if [ "$input2" == "y" ]
then
	if [ ! -d "./MetaXtract_Files_$2/" ]
	then
		mkdir ./MetaXtract_Files_$2/
	fi
	cp /tmp/metaxtract_data/* ./MetaXtract_Files_$2/
	echo ""
	echo -e " \033[38;2;255;255;0m[!] File(s) moved to ./MetaXtract_Files_$2/\033[m"
fi
rm -rf /tmp/metaxtract_data/
echo ""
echo -e " \033[38;2;255;0;0m[#] Exiting\033[m"
fi
