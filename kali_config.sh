#!/bin/bash

# Basic configuration of a new Kali Linux

if [ "$EUID" -ne 0 ]
    then
        echo;echo "[!] You must run the script as root!";echo
        exit
fi

apt-get update
apt-get upgrade -y
python3 -m pip install --upgrade pip
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
python2.7 get-pip.py
rm -rf get-pip.py
python2.7 -m pip install --upgrade pip
updatedb
systemctl enable postgresql
service start postgresql
msfdb init
printf "%s " "Press enter to finish"
read ans
