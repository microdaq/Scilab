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

/* AO channel IDs */
enum mdaq_ao_ids
{
    AO1 = 1,
    AO2,
    AO3,
    AO4,
    AO5,
    AO6,
    AO7,
    AO8,
    AO9,
    AO10,
    AO11,
    AO12,
    AO13,
    AO14,
    AO15,
    AO16
};

/* AO converter IDs */
enum mdaq_dac_ids
{
    DAC01 = 1,
    DAC02,
    DAC03,
    DAC04,
    DAC05,
    DAC06,
    DAC07
};

enum mdaq_ao_range
{
    AO_0_TO_5V = 0,
    AO_0_TO_10V,
    AO_PLUS_MINUS_5V,
    AO_PLUS_MINUS_10V,
    AO_PLUS_MINUS_2V5
};

/* AO mode */
#define AO_ASYNC    (1 << 1)
#define AO_SYNC     (1 << 2)

int mdaq_ao_init(uint32_t mode);
int mdaq_ao_write( uint8_t ch[], uint8_t ch_count, const double *value);
int mdaq_ao_ch_config(uint8_t ch[], float range[], uint8_t ch_count);
int mdaq_ao_scan_prepare_data(uint8_t ch, uint8_t range, double *value, uint32_t sample_count);

#endif /* MDAQ_AO_H */
