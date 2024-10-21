#!/bin/bash

trap ctrl_c INT

function ctrl_c() {
    echo -e "\nExiting..."
    exit 1
}

for ip in $(cat ranges); do
  echo -ne "-> $ip\r"
  if fping -c1 -t100 -g "$ip" 2>&1 | grep -q "is alive"; then
    echo $ip
  fi
done
