/* mdaq_pwm_zvsfb.h -- PWM driver for ZVSFB controller 
 *
 * Copyright (C) 2019 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */


#ifndef __mdaq_pwm_zvsfb__
#define __mdaq_pwm_zvsfb__

#include "mdaq_pwm.h"

/* ZVSFB controller functions */
void mdaq_pwm_ZVSFB_init(int32_t period, float a_channel, float b_channel);
void mdaq_pwm_ZVSFB_stop();
void mdaq_pwm_ZVSFB_start();
void mdaq_pwm_ZVSFB_write(volatile double pwm1a_duty,
        volatile double pwm1b_duty,
        volatile double pwm2a_duty,
        volatile double pwm2b_duty,
        uint16_t pwm1_dbred,
        uint16_t pwm1_dbfed,
        uint16_t pwm2_dbred,
        uint16_t pwm2_dbfed,
        uint16_t phase);

#endif /* __mdaq_pwm_zvsfb__ */
