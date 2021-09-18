/* mdaq_uart.c -- CAN bus driver for MicroDAQ device
 *
 * Copyright (C) 2020 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef MDAQ_CAN_H_
#define MDAQ_CAN_H_

#include <stdint.h>


enum mdaq_can_baud_rate
{
	B10000 = 10000,
	B20000 = 20000,
	B50000 = 50000,
	B100000 = 100000,
	B125000 = 125000,
	B250000 = 250000,
	B500000 = 500000,
	B800000 = 800000,
	B1000000 = 1000000
};


typedef struct
{
    uint8_t type;
    uint8_t len;
    uint8_t rsv1;
    uint8_t rsv2;
    uint32_t id;
    char    data[8];
}can_frame_t;

int mdaq_can_open(uint32_t baud);
int mdaq_can_write( can_frame_t *f);
int mdaq_can_read( can_frame_t *f, int timeout/* in microseconds */);

#endif /* MDAQ_CAN_H_ */
