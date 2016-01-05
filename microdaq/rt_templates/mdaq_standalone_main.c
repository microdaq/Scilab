/* MicroDAQ model Standalone main file template
*
* Copyright (C) 2015 Embedded Solutions
* All rights reserved.
*
* This software may be modified and distributed under the terms
* of the BSD license. See the LICENSE file for details.
*/

#include <stdio.h>
#include <stdint.h>

#include <xdc/std.h>
#include <xdc/runtime/Error.h>
#include <xdc/runtime/System.h>

#include <ti/sysbios/BIOS.h>
#include <ti/sysbios/knl/Task.h>
#include <ti/sysbios/knl/Clock.h>
#include <ti/sysbios/hal/Timer.h>
#include <ti/sysbios/knl/Semaphore.h>

#define MODEL_TSAMP     ($$MODEL_TSAMP$$)
#define USEC_PER_SEC    (1000000)

#define XNAME(x,y)      x##y
#define NAME(x,y)       XNAME(x,y)
#define XSTR(x)         #x
#define STR(x)          XSTR(x)uo

int NAME(MODEL, _init)(void);
int NAME(MODEL, _isr)(void);
int NAME(MODEL, _end)(void);
double NAME(MODEL, _get_tsamp)(void);

/* Real-time task */ 
void rt_task(UArg arg0);

volatile double model_exec_timer = 0.0; 
volatile double model_stop_flag = 0.0; 

double get_scicos_time( void )
{
    return model_exec_timer; 
}

double get_scicos_tsamp(void)
{
    return MODEL_TSAMP;
}

double NAME(MODEL, _get_tsamp)(void)
{ 
    return MODEL_TSAMP;
}

Int main()
{   
    Clock_Params clkParams;
    Timer_Params user_sys_tick_params;
    Timer_Handle user_sys_tick_timer;

    /* Create a periodic Clock Instance with period = 1 system time units */
    Clock_Params_init(&clkParams);      
    clkParams.period = 1;
    clkParams.startFlag = TRUE;
    Clock_create(rt_task, 2, &clkParams, NULL);

    /* Create timer for user system tick */
    Timer_Params_init(&user_sys_tick_params);
    user_sys_tick_params.period = (uint32_t)(MODEL_TSAMP * USEC_PER_SEC);
    user_sys_tick_params.periodType = Timer_PeriodType_MICROSECS;
    user_sys_tick_params.arg = 1;
    user_sys_tick_timer = Timer_create(1, 
            (ti_sysbios_hal_Timer_FuncPtr)Clock_tick, 
            &user_sys_tick_params, NULL);

    if (user_sys_tick_timer == NULL) 
        System_abort("Unable to create user system tick timer!");

    /* Init model */ 
    NAME(MODEL, _init)();

    BIOS_start();
}

/* Real-time task */ 
Void rt_task(UArg arg0)
{
    static int end_called = 0; 

	if ( model_stop_flag == 0.0 )
    {
        /* Call model isr function */ 
        NAME(MODEL, _isr)();    
    }
    else 
    {
	if(!end_called)
	{
       	    /* Call model end function */ 
       	    NAME(MODEL, _end)();    
	    end_called = 1; 
	}

    }

    /* increment execution timer */ 
    model_exec_timer += MODEL_TSAMP;
}

