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
    ADC05,
    ADC06,
    ADC07,
    ADC08,
    ADC09,
    ADC10 
};

enum mdaq_ai_error_id
{
    ERR_CHANNEL_NO          = 1,
    ERR_RANGE               = 2,
    ERR_MODE                = 3,
    ERR_POLARITY            = 4,
    ERR_MULTI_RANGE         = 5,
    ERR_CONSEC_CHANNEL      = 6,
    ERR_FIRST_CHANNEL       = 7,
    ERR_DIFF_MODE           = 8,
    ERR_DIFF_CHANNEL        = 9,
    ERR_SINGLE_MODE         = 10,
    ERR_SINGLE_CHANNEL      = 11,
    ERR_FREQ                = 12 
}; 

/* AI range */
#define AI_10V 		(1 << 0)
#define AI_5V 		(1 << 1)
#define AI_2V5  	(1 << 2)
#define AI_1V25   	(1 << 3)
#define AI_0V64     (1 << 4)

/* AI polarity */
#define AI_BIPOLAR 	(1 << 24)
#define AI_UNIPOLAR	(1 << 25)

/* AI mode */
#define AI_SINGLE  	(1 << 28)
#define AI_DIFF    	(1 << 29)

#define AI_NONE     (0)

int mdaq_ai_init(uint32_t range, uint32_t polarity, uint32_t mode);
int mdaq_ai_config_ch(uint8_t ch[], uint8_t ch_count, float range[], uint8_t mode[]);
int mdaq_ai_read( uint8_t ch[], uint8_t ch_count, double *data);
int mdaq_ai_read2(uint8_t ch[], uint8_t ch_count, uint32_t oversampling, double *data);
int mdaq_ai_scan_init(uint8_t ch[], uint8_t ch_count, float *range, uint8_t *mode, int32_t scan_count, float *freq);

int mdaq_ai_id(void);

#endif /* MDAQ_AI_H */
