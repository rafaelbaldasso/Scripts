#!/usr/bin/python3

def main():
    import hashlib,sys
    types = ['b64', 'md5', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512']
    if len(sys.argv) <= 1:
        print("\n[~] Simple hashing/encoding tool [~]")
        print("[>] Usage: ./hashcode.py [TYPE]")
        print("[>] Types: b64, md5, sha1, sha224, sha256, sha384, sha512")
    else:
        htype = sys.argv[1].lower()
        if htype not in types:
            print("\n[!] This is not a valid hash type!")
            exit()
        elif htype == "b64":
            base64()
        else: 
            value = input("\n[>] String: ").encode()
            if htype == "md5":
                print("\n" + hashlib.md5(value).hexdigest())
            elif htype == "sha1":
                print("\n" + hashlib.sha1(value).hexdigest())
            elif htype == "sha224":
                print("\n" + hashlib.sha224(value).hexdigest())
            elif htype == "sha256":
                print("\n" + hashlib.sha256(value).hexdigest())
            elif htype == "sha384":
                print("\n" + hashlib.sha384(value).hexdigest())
            elif htype == "sha512":
                print("\n" + hashlib.sha512(value).hexdigest())

def base64():
    import base64
    while True:
        choice = input("\n[>] Type E to encode or D to decode: ").lower()   
        if choice == "e":
            value = input("[>] String: ").encode()
            print("\n" + base64.b64encode(value).decode())
            break
        elif choice == "d":
            value = input("[>] Hash: ").encode()
            print("\n" + base64.b64decode(value).decode())
            break
        else:
            print("\n[!] Please choose one of the options!")
            continue

main()
