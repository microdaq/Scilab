/* mdaq_socket.h -- TCP/UDP socket driver for MicroDAQ device
 *
 * Copyright (C) 2014 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef _MDAQ_SOCKET_H_
#define _MDAQ_SOCKET_H_

#include <stdint.h>

enum mdaq_socket_type
{
	MDAQ_SOCKET_TCP,
	MDAQ_SOCKET_UDP
};


/* Client TCP/UDP socket functions */
void mdaq_socket_open( char *ip, int port, unsigned char blocking, int timeout, unsigned char type);
void mdaq_socket_send( char *ip, int port, unsigned char *data, unsigned int size);
void mdaq_socket_recv( char *ip, int port, unsigned char *data, int *status, unsigned int size, unsigned char blocking );
void mdaq_socket_close( char *ip, int port );

#endif /* _MDAQ_SOCKET_H_ */

