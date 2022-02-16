#!/bin/bash

if [ "$1" == "" ]
then
        echo ""
	echo " [>] Requirements: assetfinder, Amass, httprobe"
        echo " [>] Usage: sudo sub_collector.sh <TARGET>"
else
echo ""
echo " [>] Harvesting subdomains with assetfinder..."
assetfinder -subs-only $1 >> assets.txt
echo ""
echo " [>] Harvesting subdomains with Amass..."
amass enum -silent -d $1 >> assets.txt
sort -u assets.txt >> total_assets.txt
rm assets.txt
echo ""
echo " [>] Validating the subdomains with httprobe..."
cat total_assets.txt | httprobe | sed 's/http\?:\/\///' |  sed 's/https\?:\/\///' | sort -u >> $1.txt
rm total_assets.txt
echo ""
echo " [>] Process finished. Results saved into $1.txt"
fi
