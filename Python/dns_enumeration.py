# Based on Joe Helle's 'Python DNS Enumeration Tool' video!

import dns.resolver # pip install dnspython
import sys

def begin():
    print('\n[#] DNS Enumeration Tool')

    try:
        domain = sys.argv[1]
        main(domain)
    except IndexError:
        print(f'\n[>] Syntax Error: python {sys.argv[0]} <domain>')
        print(f'[>] Example: python {sys.argv[0]} google.com')
        quit()

def main(domain):
    dns_records = ['A', 'AAAA', 'NS', 'CNAME', 'MX', 'PTR', 'SOA', 'TXT']

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
            print(f'\n[>] \"{domain}\" doesn\'t exist!')
            quit()
        except KeyboardInterrupt:
            print('\n[>] Query interrupted, quitting!')
            quit()

begin()