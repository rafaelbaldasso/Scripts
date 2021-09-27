#!/usr/bin/python3

import socket

print("\n [#] FTP Server Login Interaction\n")

ip = input(" [>] Type the IP or URL: ")
port = 21

# Creates the socket
mysocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
mysocket.connect((ip,port))

# Grabs the banner
banner = mysocket.recv(1024)
print("")
print(" [+]",banner.decode())

# Sends the USER
usr = input(" [>] User: ")
usr_send = "USER {} \r\n".format(usr)
mysocket.send(usr_send.encode())
resp = mysocket.recv(1024)
print("")
print(" [+]",resp.decode())

# Sends the PASSWORD
passd = input(" [>] Password: ")
passd_send = "PASS {} \r\n".format(passd)
mysocket.send(passd_send.encode())
resp = mysocket.recv(1024)
print("")
print(" [+]",resp.decode())
