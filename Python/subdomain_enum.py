# Based on Joe Helle's 'Python Subdomain Enumeration Tool' video!

import dns.resolver # pip install dnspython
import sys

def begin():
    print('\n[#] Subdomain Enumeration Tool\n')

    try:
        domain = sys.argv[1]
        with open(sys.argv[2], 'r') as x:
            wordlist = x.read().split()
        main(domain,wordlist)
    except IndexError:
        print(f'[>] Syntax Error: python {sys.argv[0]} <domain> <wordlist>')
        print(f'[>] Example: python {sys.argv[0]} google.com subdomains.txt')
        quit()

def main(domain,wordlist):
    for sub in wordlist:
        try:
            subdomain = str(f'{sub}.{domain}')
            addr = dns.resolver.resolve(subdomain, 'A')
            if addr:
                print(subdomain)
            else:
                continue
        except dns.resolver.NXDOMAIN:
            pass
        except dns.resolver.NoAnswer:
            pass
        except KeyboardInterrupt:
            print('\n[#] Query interrupted, quitting!')
            quit()

    print('\n[#] Finished')

begin()