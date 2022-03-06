#!/bin/bash

# If parameters are empty, display how to use the script
if [ "$1" == "" ] || [ "$2" == "" ]
then
    echo ""
    echo " [>] Usage: $0 targetIP WORDLIST"
else
    # Create 2 lists to store the shares names during the tests
    found=()
    access=()
    # Provide a wordlist with share names to enumerate
    shares=$(cat $2)
    for share in $shares;do
	# Default user is null %, no password, empty command string
        command=$(smbclient \\\\$1\\$share -U '%' -N -c '')
        if [ "$command" == "" ]
        then
	    access+=($share)
        elif [ "$command" == "tree connect failed: NT_STATUS_ACCESS_DENIED" ]
	then
	    found+=($share)
	# If the share doesn't exist (error NT_STATUS_BAD_NETWORK_NAME) then it is discarded
	fi
    done
    echo ""
    echo " [!] Accessible shares: ${access[@]}"
    echo " [>] Other shares found: ${found[@]}"
fi
