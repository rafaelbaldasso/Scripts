#!/usr/bin/python3

import requests

print("\n [#] Web Server Info ~ by Kothmun")

addr = input("\n [>] Site: ")
url = "http://"+addr

site = requests.get(url)
print("\n [+] Status code:",site.status_code)
print("\n [+] Web Server:",site.headers['Server'],"\n")
