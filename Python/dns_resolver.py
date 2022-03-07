# Based on Joe Helle's 'Python DNS Enumeration Tool' video!

import dns.resolver # pip install dnspython
import sys

dns_records = ['A', 'AAAA', 'NS', 'CNAME', 'MX', 'PTR', 'SOA', 'TXT']

try:
    domain = sys.argv[1]
except IndexError:
    print(f'\n[>] Syntax Error - python3 {sys.argv[0]} <domain>\n')
    quit()

for record in dns_records:
    try:
        answer = dns.resolver.resolve(domain, record)
        print(f'\n{record}')
        print('-'*30)
        for server in answer:
            print(server.to_text())
    except dns.resolver.NoAnswer:
        pass
    except dns.resolver.NXDOMAIN:
        print(f'\n[>] \"{domain}\" doesn\'t exist!\n')
        quit()
    except KeyboardInterrupt:
        print('\n[>] Query interrupted, quitting!\n')
        quit()
        
print('')