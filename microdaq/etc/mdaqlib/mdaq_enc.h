/* mdaq_enc.h -- Encoder driver for MicroDAQ device
 *
 * Copyright (C) 2013 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef MDAQ_ENC_H_
#define MDAQ_ENC_H_

#include <stdint.h>

enum mdaq_enc_ids
{
	ENC1 = 1,
	ENC2 = 2
};

enum mdaq_enc_mode
{
	QUADRATURE = 0,
	DIR_COUNT= 1, 
	UP_COUNT = 2, 
	DOWN_COUNT = 3
};

void mdaq_enc_init(uint8_t enc, uint8_t mode, int32_t init_value);
int32_t mdaq_enc_read(uint8_t enc);

#endif /* MDAQ_ENC_H_ */
