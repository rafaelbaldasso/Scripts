#!/bin/bash
if [ "$1" == "" ]
then
  echo " Please provide the wordlist path/name - example:"
	echo " $0 /usr/share/john/password.lst" 
else
for i in $(cat $1);
do
	echo -n "$i" | md5sum | cut -d " " -f1 | base64 | sed 's/K$/=/' > temphashlist
		for j in $(cat temphashlist);
		do
			echo -n "$i | " >> newhashlist
			echo -n "$j" | sha1sum | sed 's/  -$//' >> newhashlist
		done
done
rm -rf temphashlist
fi
