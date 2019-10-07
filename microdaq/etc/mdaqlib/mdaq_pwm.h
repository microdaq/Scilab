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

/* TBCTL (Time-Base Control) */
// TBCNT MODE
#define TB_COUNT_UP         0x0
#define TB_COUNT_DOWN       0x1
#define TB_COUNT_UPDOWN     0x2
#define TB_FREEZE           0x3

// PHSEN
#define TB_DISABLE          0x0
#define TB_ENABLE           0x1

// PRDLD
#define TB_SHADOW           0x0
#define TB_IMMEDIATE        0x1

// SYNCOSEL
#define TB_SYNC_IN          0x0
#define TB_CTR_ZERO         0x1
#define TB_CTR_CMPB         0x2
#define TB_SYNC_DISABLE     0x3

// HSPCLKDIV and CLKDIV
#define TB_DIV1             0x0
#define TB_DIV2             0x1
#define TB_DIV4             0x2

// PHSDIR bit
#define TB_DOWN             0x0
#define TB_UP               0x1

// CMPCTL (Compare Control)
// LOADAMODE and LOADBMODE bits
#define CC_CTR_ZERO         0x0
#define CC_CTR_PRD          0x1
#define CC_CTR_ZERO_PRD     0x2
#define CC_LD_DISABLE       0x3

// SHDWAMODE and SHDWBMODE bits
#define CC_SHADOW           0x0
#define CC_IMMEDIATE        0x1

// Dead-Band Control
// MODE bit
#define DB_DISABLE          0x0
#define DBA_ENABLE          0x1
#define DBB_ENABLE          0x2
#define DB_FULL_ENABLE      0x3

// POLSEL bit
#define DB_ACTV_HI          0x0
#define DB_ACTV_LOC         0x1
#define DB_ACTV_HIC         0x2
#define DB_ACTV_LO          0x3

enum mdaq_pwm_module_id
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

/* basic PWM function */ 
int mdaq_pwm_init(uint8_t module, int32_t period, uint8_t active_low, float a_channel, float b_channel);
void mdaq_pwm_write(uint8_t module, float a_channel, float b_channel);

/* advanced PWM functions */ 
void mdaq_pwm_start(uint8_t channel);
void mdaq_pwm_stop(uint8_t channel);
void mdaq_pwm_set_period(uint8_t channel, uint32_t period);
void mdaq_pwm_set_duty(uint8_t channel, float duty);
void mdaq_pwm_set_polarity(uint8_t channel, uint8_t polarity);

void mdaq_pwm_tb_sync(uint8_t module, uint8_t phsen, uint8_t syncosel );
void mdaq_pwm_tb_set_phase(uint8_t module, uint16_t phase);

void mdaq_pwm_db_setup(uint8_t module, uint8_t mode, uint8_t polsel );
void mdaq_pwm_db_set_delay(uint8_t module, uint16_t red, uint16_t fed);

#endif /* MDAQ_PWM_H_ */
