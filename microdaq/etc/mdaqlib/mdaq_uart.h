/* mdaq_uart.c -- Uart driver for MicroDAQ device
 *
 * Copyright (C) 2014 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef MDAQ_FILE_H_
#define MDAQ_FILE_H_

#include <stdint.h>

enum mdaq_uart_baud_rate
{
	B2400 = 2400,
	B4800 = 4800,
	B9600 = 9600,
	B19200 = 19200,
	B38400 = 38400,
	B57600 = 57600,
	B115200 = 115200,
	B230400 = 230400,
	B460800 = 460800,
	B500000 = 500000,
	B576000 = 576000,
	B921600 = 921600,
	B1000000 = 1000000,
	B1152000 = 1152000,
	B1500000 = 1500000,
    B2000000 = 2000000,
    B2500000 = 2500000,
    B3000000 = 3000000
};

enum mdaq_uart_parity
{
	PARITY_NONE = 1,
	PARITY_EVEN = 2,
	PARITY_ODD =  4
};

enum mdaq_uart_stop_bits
{
    STOP_BITS_1    = 1,
    STOP_BITS_1_5  = 2,
    STOP_BITS_2    = 4
};


typedef struct mdaq_uart_config_
{
	int baud_rate;
	int data_bits;
	int parity;
	int stop_bits;
}mdaq_uart_config_t;

int mdaq_uart_open(mdaq_uart_config_t *c);
int mdaq_uart_write( void *data, int len);
int mdaq_uart_read( void *data, int len, int timeout/* in microseconds */);

#endif /* MDAQ_FILE_H_ */
