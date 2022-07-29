#include <stdio.h>
#include <string.h>
#include <netinet/in.h>
#include <arpa/inet.h>      // Needed for inet_ntoa()
#include <fcntl.h>
#include <netdb.h>
#include <sys/socket.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <signal.h>         // Needed for Signal int handler
#include <errno.h>

#define GROUP_ADDR 	"239.255.255.255"
#define PORT_NUM	27015

int broadcast_sock;

void m_searcher(void);

void
main(void)
{
	unsigned char TTL = 1;
	broadcast_sock = socket(AF_INET, SOCK_DGRAM, 0);
	if (setsockopt(broadcast_sock, IPPROTO_IP, IP_MULTICAST_TTL, (char *)&TTL, sizeof(TTL)) < 0) {
		puts("setsockopt error");
	}

	m_searcher();
}

void
m_searcher(void)
{
    struct sockaddr_in 	addr_dest;
	unsigned int 		addr_len;
    unsigned int        sock = broadcast_sock;
	char				buffer[1024];

	memset(buffer, 0xff, 1024);

    addr_dest.sin_family = AF_INET;
	addr_dest.sin_addr.s_addr = inet_addr(GROUP_ADDR);
	addr_dest.sin_port = htons(PORT_NUM);
	addr_len = sizeof(addr_dest);

    // Multicast the message forever with a period of 1 second
	printf("*** Sending multicast datagrams to '%s' (port = %d) \n", GROUP_ADDR, PORT_NUM);



	while (1) {
		// Send buffer as a datagram to the multicast group
		// sendto(sock, m_search_format, strlen(m_search_format), 0, (struct sockaddr*)&addr_dest, addr_len);
		sendto(sock, buffer, 1024, 0, (struct sockaddr*)&addr_dest, addr_len);

		usleep(1);
	}
}
