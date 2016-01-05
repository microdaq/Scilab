/* mdaq_webscope.h -- Webscope driver for MicroDAQ device
 *
 * Copyright (C) 2015 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef MDAQWEBSCOPE_H_
#define MDAQWEBSCOPE_H_

#include <stdint.h>
#include <string.h>

int mdaq_webscope_open(uint32_t freq, double ymax, double ymin, double trig_level, double trig_offset, uint32_t buf_size, uint32_t vector_size);
int mdaq_webscope_write(double *data, uint32_t size);


#endif /* MDAQWEBSCOPE_H_ */
