/* Generated with MicroDAQ toolbox ver: 1.3.0 */
#include "scicos_block4.h"
#include "mdaq_pwm.h"

extern double get_scicos_time( void );

/* This function will executed once at the beginning of model execution */
static void init(scicos_block *block)
{
    /* Block parameters */
    double *params = GetRparPtrs(block);

    /* param size = 1 */
    double pwm_period = params[0];
    /* param size = 1 */
    double default_duty = params[1];

    /* Add block init code here */
    mdaq_pwm_ZVSFB_init((int32_t)pwm_period, (float)default_duty, (float)default_duty );
}

/* This function will be executed on every model step */

static void inout(scicos_block *block)
{
    static int first_time = 1; 

    /* Block parameters */
    double *params = GetRparPtrs(block);
    /* param size = 1 */
    double pwm_period = params[0];
    /* param size = 1 */
    double default_duty = params[1];

    /* Block input ports */
    double *u1 = GetRealInPortPtrs(block,1);
    int u1_size = GetInPortRows(block,1);    /* u1_size = 4 */

    double *u2 = GetRealInPortPtrs(block,2);
    int u2_size = GetInPortRows(block,2);    /* u2_size = 1 */

    double *u3 = GetRealInPortPtrs(block,3);
    int u3_size = GetInPortRows(block,3);    /* u3_size = 1 */

    double *u4 = GetRealInPortPtrs(block,4);
    int u4_size = GetInPortRows(block,4);    /* u4_size = 1 */

    double *u5 = GetRealInPortPtrs(block,5);
    int u5_size = GetInPortRows(block,5);    /* u5_size = 1 */

    double *u6 = GetRealInPortPtrs(block,6);
    int u6_size = GetInPortRows(block,6);    /* u5_size = 1 */

    /* Add block code here (executed every model step) */
    mdaq_pwm_ZVSFB_write(u1[0], u1[1], u1[2], u1[3], (uint16_t)*u2, (uint16_t)*u3, (uint16_t)*u4, (uint16_t)*u5, (uint16_t)*u6);
    if(first_time)
    {
        /* Start PWM modules only once */ 
        mdaq_pwm_ZVSFB_start();
        first_time = 0;
    }
}

/* This function will be executed once at the end of model execution (only in Ext mode) */
static void end(scicos_block *block)
{
    /* Prameters */
    double *params = GetRparPtrs(block);

    /* param size = 1 */
    double pwm_period = params[0];
    /* param size = 1 */
    double default_duty = params[1];

    /* Add block end code here */
    mdaq_pwm_ZVSFB_stop();
}

void mdaq_zvsfb(scicos_block *block,int flag)
{
    if (flag == 1){            /* set output */
        inout(block);
    }
    else if (flag == 5){       /* termination */
        end(block);
    }
    else if (flag == 4){       /* initialisation */
        init(block);
    }
}
