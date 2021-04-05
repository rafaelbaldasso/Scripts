#!/usr/bin/python3

import socket,sys

if len(sys.argv) <= 1:
        print("\n [#] Port Scan ~ by Kothmun\n")
        print(" [>] Usage: ./port_scan.py HOST")
        print(" [>] Example: ./port_scan.py 172.16.1.100\n")
else:
        print("\n [#] Port Scan ~ by Kothmun\n")
        print(" [>] Target: {}\n".format(sys.argv[1]))
        print(" [>] Open Ports:")

        for port in range(1,65536):
                mysocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                if mysocket.connect_ex((sys.argv[1],port)) == 0:
                        print(" [+]",port)
                        mysocket.close()
        print("")                
