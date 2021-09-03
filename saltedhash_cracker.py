#!/usr/bin/python3

import crypt

print("\n[+] Usage example:")
print("[!] Salt (everything before the hash value): $y$j9T$4PJ8qQOXO0r5j9eXh9crq.$")
print("[!] Hash (everything after the last '$'): eIIddmVCzUnbL0/dgzR7jBXXCCce8GGEPEZhtGylAbA")
salt = str(input("\n[>] Paste the salt: "))
hash = str(input("[>] Paste the hash: "))
value = str(salt+hash)

# Choose a wordlist
wordlist = open('/usr/share/john/password.lst', 'r')
#wordlist = open('/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt', 'r')
#wordlist = open('/usr/share/wordlists/rockyou.txt', 'r')

for line in wordlist:
    password = line.strip()
    found = str(crypt.crypt(password,salt))
    if found == value:
        print("\nThe password is: " + password)
        wordlist.close()
        exit()
    else:
        continue

print("[!] Password not found.")
wordlist.close()
