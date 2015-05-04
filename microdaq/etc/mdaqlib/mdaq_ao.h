/* mdaq_ao.h -- DAC driver for MicroDAQ device
 *
 * Copyright (C) 2013 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef MDAQ_AO_H
#define MDAQ_AO_H

#include <stdint.h>

enum mdaq_ao_ids
{
	AO1 = 1,
	AO2,
	AO3,
	AO4,
	AO5,
	AO6,
	AO7,
	AO8
};

enum mdaq_dac_ids
{
	DAC01 = 1,
	DAC02,
	DAC03
};

#define AO_ASYNC		(1 << 1)
#define AO_SYNC			(1 << 2)

int mdaq_ao_init( uint8_t converter,  uint8_t mode);
int mdaq_ao_write( uint8_t ch[], uint8_t ch_count, const float *value);

#endif /* MDAQ_AO_H */
