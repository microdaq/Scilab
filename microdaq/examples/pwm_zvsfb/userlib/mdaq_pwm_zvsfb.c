/* mdaq_pwm_zvsfb.c -- PWM driver for ZVSFB controller 
 *
 * Copyright (C) 2019 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

/* ZVSFB controller functions */ 

#include "mdaq_pwm.h"

/* ZVSFB controller functions */
void mdaq_pwm_ZVSFB_init(int32_t period, float a_channel, float b_channel)
{
    uint8_t module;
    uint8_t active_low = 0;

        /* Configure PWM1 - channel A and B */ 
    module = PWM1;
    module--;
    module *= 2;

    /* Configure PWM frequency */ 
    mdaq_pwm_set_period(module, period);
    mdaq_pwm_set_period( module + 1, period);

    /* Setup polarity */ 
    mdaq_pwm_set_polarity(module, active_low);
    mdaq_pwm_set_polarity( module + 1, active_low);

    /* Set PWM initial duty for channel A and B in precent */ 
    mdaq_pwm_set_duty(module, a_channel);
    mdaq_pwm_set_duty(module + 1, b_channel);

    /* 
     * Configure time base and dead-band module - see http://www.ti.com/lit/pdf/spruh92
     * Table16-48, Table16-49 for more details.
     */ 
    mdaq_pwm_tb_sync(module, TB_DISABLE, TB_CTR_ZERO);
    mdaq_pwm_db_setup(module, DB_FULL_ENABLE, DB_ACTV_HIC);

    module = PWM2;
    module--;
    module *= 2;

    /* Configure PWM frequency */ 
    mdaq_pwm_set_period(module, period);
    mdaq_pwm_set_period( module + 1, period);

    /* Setup polarity */ 
    mdaq_pwm_set_polarity(module, active_low);
    mdaq_pwm_set_polarity( module + 1, active_low);

    mdaq_pwm_set_duty(module, a_channel);
    mdaq_pwm_set_duty(module + 1, b_channel);

    mdaq_pwm_tb_sync(module, TB_ENABLE, TB_SYNC_IN );
    mdaq_pwm_db_setup(module, DB_FULL_ENABLE, DB_ACTV_HIC);
}

void mdaq_pwm_ZVSFB_stop(void)
{
    mdaq_pwm_stop(0);
    mdaq_pwm_stop(1);
    mdaq_pwm_stop(2);
    mdaq_pwm_stop(3);
}

void mdaq_pwm_ZVSFB_start(void)
{
    mdaq_pwm_start(0);
    mdaq_pwm_start(1);
    mdaq_pwm_start(2);
    mdaq_pwm_start(3);
}

void mdaq_pwm_ZVSFB_write(volatile double pwm1a_duty,
        volatile double pwm1b_duty,
        volatile double pwm2a_duty,
        volatile double pwm2b_duty,
        uint16_t pwm1_dbred,
        uint16_t pwm1_dbfed,
        uint16_t pwm2_dbred,
        uint16_t pwm2_dbfed,
        uint16_t phase)
{
    mdaq_pwm_set_duty(0, pwm1a_duty);
    mdaq_pwm_set_duty(1, pwm1b_duty);
    mdaq_pwm_set_duty(2, pwm2a_duty);
    mdaq_pwm_set_duty(3, pwm2b_duty);

    mdaq_pwm_db_set_delay(0, pwm1_dbred, pwm1_dbfed);
    mdaq_pwm_db_set_delay(2, pwm2_dbred, pwm2_dbfed);

    mdaq_pwm_tb_set_phase(2, phase);
}

