/* mdaq_net.h -- Socket driver for MicroDAQ device
 *
 * Copyright (C) 2013 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef MDAQNET_H_
#define MDAQNET_H_

#include <stdio.h>
#define EAGAIN      11  /* Try again */
#define EWOULDBLOCK EAGAIN

#define MSG_OOB					1
#define MSG_PEEK				2
#define MSG_DONTROUTE			4
#define MSG_TRYHARD     		4       /* Synonym for MSG_DONTROUTE for DECnet */
#define MSG_CTRUNC				8
#define MSG_PROBE				0x10	/* Do not send. Only probe path f.e. for MTU */
#define MSG_TRUNC				0x20
#define MSG_DONTWAIT			0x40	/* Nonblocking io		 */
#define MSG_EOR         		0x80	/* End of record */
#define MSG_WAITALL				0x100	/* Wait for a full request */
#define MSG_FIN         		0x200
#define MSG_SYN					0x400
#define MSG_CONFIRM				0x800	/* Confirm path validity */
#define MSG_RST					0x1000
#define MSG_ERRQUEUE			0x2000	/* Fetch message from error queue */
#define MSG_NOSIGNAL			0x4000	/* Do not generate SIGPIPE */
#define MSG_MORE				0x8000	/* Sender will send more */
#define MSG_WAITFORONE			0x10000	/* recvmmsg(): block until 1+ packets avail */
#define MSG_SENDPAGE_NOTLAST 	0x20000 /* sendpage() internal : not the last page */
#define MSG_EOF         		MSG_FIN

enum sock_type{
	SOCK_STREAM = 1,
	SOCK_DGRAM  = 2,
	SOCK_RAW    = 3,
	SOCK_RDM    = 4,
	SOCK_SEQPACKET  = 5,
	SOCK_DCCP   = 6,
	SOCK_PACKET = 10
};

enum protocol_type{
	IPPROTO_IP = 0,               /* Dummy protocol for TCP               */
	IPPROTO_ICMP = 1,             /* Internet Control Message Protocol    */
	IPPROTO_IGMP = 2,             /* Internet Group Management Protocol   */
	IPPROTO_IPIP = 4,             /* IPIP tunnels (older KA9Q tunnels use 94) */
	IPPROTO_TCP = 6,              /* Transmission Control Protocol        */
	IPPROTO_EGP = 8,              /* Exterior Gateway Protocol            */
	IPPROTO_PUP = 12,             /* PUP protocol                         */
	IPPROTO_UDP = 17,             /* User Datagram Protocol               */
	IPPROTO_IDP = 22,             /* XNS IDP protocol                     */
	IPPROTO_DCCP = 33,            /* Datagram Congestion Control Protocol */
	IPPROTO_RSVP = 46,            /* RSVP protocol                        */
	IPPROTO_GRE = 47,             /* Cisco GRE tunnels (rfc 1701,1702)    */

	IPPROTO_IPV6   = 41,          /* IPv6-in-IPv4 tunnelling              */

	IPPROTO_ESP = 50,            /* Encapsulation Security Payload protocol */
	IPPROTO_AH = 51,             /* Authentication Header protocol       */
	IPPROTO_BEETPH = 94,         /* IP option pseudo header for BEET */
	IPPROTO_PIM    = 103,         /* Protocol Independent Multicast       */

	IPPROTO_COMP   = 108,                /* Compression Header protocol */
	IPPROTO_SCTP   = 132,         /* Stream Control Transport Protocol    */
	IPPROTO_UDPLITE = 136,        /* UDP-Lite (RFC 3828)                  */

	IPPROTO_RAW    = 255,         /* Raw IP packets                       */
	IPPROTO_MAX
};

#define MDAQNET_NONOS		(0)
#define MDAQNET_SYSBIOS		(1)

#define MDAQNET_MAX_SOCKET  (16)

int mdaq_net_init( void );

int mdaq_net_open(int port, int type, int protocol, int flags, int blocking);
int mdaq_net_close(int fd);
int mdaq_net_recv(int fd, void *buf, size_t len, int flags);
int mdaq_net_send(int fd, const void *buf, size_t len, int flags);

#endif /* MDAQNET_H_ */
