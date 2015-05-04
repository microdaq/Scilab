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
	B115200 = 115200
};

enum mdaq_uart_polarity
{
	NONE = 0,
	EVEN = 1,
	ODD = 2
};

typedef struct mdaq_uart_config_
{
	int baud_rate;
	int data_bits;
	int parity;
	int stop_bits;
	int flow_control;
}mdaq_uart_config_t;

int mdaq_uart_open(int port_num);
int mdaq_uart_write(int port, void *data, int len);
int mdaq_uart_read(int port, void *data, int len, int timeout);
int mdaq_uart_setspeed(int speed);
int mdaq_uart_config(int port, mdaq_uart_config_t *c );
int mdaq_uart_close(int port);
int mdaq_uart_init(void);


#endif /* MDAQ_FILE_H_ */
