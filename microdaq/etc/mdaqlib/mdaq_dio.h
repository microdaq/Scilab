/* mdaq_dio.h -- DIO driver for MicroDAQ device
 *
 * Copyright (C) 2013 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */ 

#ifndef MDAQ_DIO_
#define MDAQ_DIO_

#include <stdint.h>

#define     LOW     (0)
#define     HIGH    (1)


/* DIO channels */
enum mdaq_dio_ids
{
	DIO1 = 1,
	DIO2, 
	DIO3, 
	DIO4, 
	DIO5, 
	DIO6, 
	DIO7, 
	DIO8, 
	DIO9, 
	DIO10, 
	DIO11, 
	DIO12, 
	DIO13, 
	DIO14, 
	DIO15, 
	DIO16,
	DIO17,
	DIO18,
	DIO19,
	DIO20,
	DIO21,
	DIO22,
	DIO23,
	DIO24,
	DIO25,
	DIO26,
	DIO27,
	DIO28,
	DIO29,
	DIO30,
	DIO31,
	DIO32,
	F1,
	F2,
	D1,
	D2
};

enum mdaq_bank_ids
{
	DIO_BANK1 = 1,
	DIO_BANK2,
	DIO_BANK3,
	DIO_BANK4
};

enum mdaq_dio_func_ids
{
	ENC1_FUNC,
	ENC2_FUNC,
	PWM1_FUNC,
	PWM2_FUNC,
	PWM3_FUNC,
	UART_FUNC
};

enum mdaq_bank_dir_ids
{
    DIO_OUTPUT = 0,
    DIO_INPUT = 1
};

void mdaq_bank_dir( uint8_t bank, uint8_t dir);
int  mdaq_dio_func( uint8_t function, uint8_t enable);
void mdaq_dio_write( uint8_t dio, uint8_t value);
uint8_t mdaq_dio_read( uint8_t dio);

#endif /* MDAQ_DIO_ */ 
