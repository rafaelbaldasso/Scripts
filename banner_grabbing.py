#!/usr/bin/python3

import socket,sys

if len(sys.argv) <= 2:
        print("\n [#] Banner Grabbing ~ by Kothmun\n")
        print(" [>] Usage: ./banner_grabbing.py HOST PORT")
        print(" [>] Example: ./banner_grabbing.py 172.16.1.100 21\n")
else:
        print("\n [#] Banner Grabing ~ by Kothmun\n")
        print(" [>] Target: {}:{}\n".format(sys.argv[1],sys.argv[2]))
        mysocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        if mysocket.connect_ex((sys.argv[1],int(sys.argv[2]))) != 0:
            print(" [!] The target port is closed\n")
        else:    
            banner = mysocket.recv(1024)
            print(" [+] {}".format(banner.decode()))
        mysocket.close()