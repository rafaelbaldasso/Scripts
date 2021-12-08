#!/bin/bash

if [ "$1" == "" ]
then
    echo ""
    echo " [>] Usage: $0 targetIP"
else
    found=()
    access=()
    # More shares can be added to the list below
    shares="C$ ADMIN$ IPC$ FAX$ PRINT$ D$ E$"
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
