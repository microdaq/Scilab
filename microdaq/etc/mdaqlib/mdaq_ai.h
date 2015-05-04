/* mdaq_ai.h -- Adc driver for MicroDAQ device
 *
 * Copyright (C) 2013 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */


#ifndef MDAQ_AI_H
#define MDAQ_AI_H

#include <stdint.h>

/* AI channels */
enum mdaq_ai_ids
{
	AI1 = 1,
    AI2,
    AI3,
    AI4,
    AI5,
    AI6,
    AI7,
    AI8,
    AI9,
    AI10,
    AI11,
    AI12,
    AI13,
    AI14,
    AI15,
    AI16
};

/* AI converters */
enum mdaq_adc_ids
{
	ADC01 = 1,
	ADC02,
	ADC03,
	ADC04,
	ADC05
};

/* AI range */
#define AI_10V 		(1 << 0)
#define AI_5V 		(1 << 1)
#define AI_2V5  	(1 << 2)
#define AI_2V   	(1 << 3)

/* AI polarity */
#define AI_BIPOLAR 	(1 << 8)
#define AI_UNIPOLAR	(1 << 9)

/* AI mode */
#define AI_SINGLE  	(1 << 16)
#define AI_DIFF    	(1 << 17)


int mdaq_ai_init(uint8_t converter, uint32_t range, uint32_t polarity, uint32_t mode);
int mdaq_ai_config_ch(uint8_t ch[], uint8_t ch_count);
int mdaq_ai_read(uint8_t ch[], uint8_t ch_count, uint16_t *adc_value, float *value);

#endif /* MDAQ_AI_H */
