#include <stdio.h>
#include <sys/socket.h>
#include <netdb.h>

int main(int argc, char *argv[]){

    int mysocket;
    int connects;

    int port;
    int start = 0;
    int finish = 65535;
    char *dest;
    dest = argv[1];

    struct sockaddr_in target;

    if(argc <= 1){

        printf("\n [#] Port Scan (Internal) ~ by Kothmun\n");
        printf("\n [>] Usage: ./port_scan_internal HOST");
        printf("\n [>] Example: ./port_scan_internal 172.16.1.100\n");
        printf("\n");
        return 0;

    } else {

            printf("\n [#] Port Scan (Internal) ~ by Kothmun\n");
            printf("\n [>] Target: %s \n",dest);
            printf("\n [>] Open Ports:\n");

            for(port=start;port<finish;port++){

            mysocket = socket(AF_INET,SOCK_STREAM,0);
            target.sin_family = AF_INET;
            target.sin_port = htons(port);
            target.sin_addr.s_addr = inet_addr(dest);

            connects = connect(mysocket, (struct sockaddr *)&target,sizeof target);

            if(connects == 0){
                printf(" [+] %d\n",port);
                close(mysocket);
                close(connects);
            } else {
                close(mysocket);
                close(connects);
            }
            }
    printf("\n");
    }
}
