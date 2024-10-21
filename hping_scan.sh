#!/bin/bash

trap ctrl_c INT

function ctrl_c() {
    echo -e "\nExiting..."
    exit 1
}

for ip in $(cat ips.txt); do
  echo -ne "-> $ip\r"
  if hping3 -S -p 80 -c 1 "$ip" 2>&1 | grep -q "flags=SA"; then
    echo $ip
  fi
done
