#!/usr/bin/python3

import socket,os,sys

if len(sys.argv) <= 1:
    print("\n [#] FTP Anonymous Login Test ~ by Kothmun\n")
    print(" [>] Usage: ./ftp_anonymous.py HOST")
    print(" [>] Example: ./ftp_anonymous.py 172.16.1.100\n")
else:
    print("\n [#] FTP Anonymous Login Test ~ by Kothmun\n")
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((sys.argv[1],21))
    print(" [>] Banner:",s.recv(1024).decode())
    s.send("USER anonymous\r\n".encode())
    print("",s.recv(1024).decode())
    s.send("PASS \r\n".encode())
    print("",s.recv(1024).decode())
    
    #os.system("nc -nv sys.argv[1] 443")
