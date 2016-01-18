/* mdaq_pwm.h -- PWM driver for MicroDAQ
 *
 * Copyright (C) 2013 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef MDAQ_PWM_H_
#define MDAQ_PWM_H_

#include <stdint.h>

enum mdaq_pwm_ids
{
	PWM1 = 1,
	PWM2,
	PWM3
};

enum mdaq_pwm_polarity
{
	ACTIVE_HIGH = 0,
	ACTIVE_LOW
};

int mdaq_pwm_init(uint8_t module, int32_t period, uint8_t active_low, float a_channel, float b_channel);
void mdaq_pwm_write(uint8_t module, float a_channel, float b_channel);

#endif /* MDAQ_PWM_H_ */
