/* mdaq_pru.h -- PRU driver for MicroDAQ device
 *
 * Copyright (C) 2013 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef _MDAQ_PRU_H_
#define _MDAQ_PRU_H_

#include <stdint.h>

enum mdaq_pru_ids
{
    PRU0 = 0,
    PRU1
};

int mdaq_pru_load(uint8_t pru_num, const uint32_t *pru_code, uint32_t code_size);
int mdaq_pru_start(uint8_t pru_num);
int mdaq_pru_stop (uint8_t pru_num);

uint32_t mdaq_pru_reg_read(uint8_t pru_num, uint8_t reg_num);
void mdaq_pru_reg_write(uint8_t pru_num, uint8_t reg_num, uint32_t reg_value);

#endif /* _MDAQ_PRU_H_ */

