/* MicroDAQ model Ext main file template
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
#define MODEL_DURATION  ($$MODEL_DURATION$$)

$$MODEL_PROFILING$$

#define USEC_PER_SEC    (1000000)

#define XNAME(x,y)      x##y
#define NAME(x,y)       XNAME(x,y)
#define XSTR(x)         #x
#define STR(x)          XSTR(x)uo

int NAME(MODEL, _init)(void);
int NAME(MODEL, _isr)(double t);
int NAME(MODEL, _end)(void);
double NAME(MODEL, _get_tsamp)(void);

/* Real-time task */ 
void rt_task(UArg arg0);

volatile double model_exec_timer = 0.0; 
volatile double model_stop_flag = 0.0;
volatile double ext_mode = 1.0;

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
    Task_Handle signal_task;    
    Clock_Params clkParams;
    Timer_Params user_sys_tick_params;
    Timer_Handle user_sys_tick_timer;
    Error_Block eb;

#ifdef MODEL_PROFILING
    int32_t t_begin, t_end;
#endif 

    Error_init(&eb);

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

    signal_task = (Task_Handle)signal_init(&eb);
    if (signal_task == NULL) 
        System_abort("Signal task: Task_create() failed!\n");

#ifdef MODEL_PROFILING
    mdaq_profile_init(); 
    t_begin = mdaq_profile_read_timer32(); 
#endif 

    /* Init model */ 
    NAME(MODEL, _init)();

#ifdef MODEL_PROFILING
    t_end = mdaq_profile_read_timer32(); 
    mdaq_profile_save(t_end - t_begin,0);
#endif

    /* Open mdaqnet and wait for connection */ 
    mdaqnet_open();

    BIOS_start();
}

/* Real-time task */ 
Void rt_task(UArg arg0)
{
    static int end_called = 0; 

#ifdef MODEL_PROFILING
    int32_t t_begin, t_end;
#endif 

    /* This condition determine if model step/isr is executed */ 
    if( model_stop_flag == 0.0 && ( model_exec_timer <= MODEL_DURATION || MODEL_DURATION == -1 ))
    {

#ifdef MODEL_PROFILING
        t_begin = mdaq_profile_read_timer32(); 
#endif 

        /* Call model isr function */ 
        NAME(MODEL, _isr)(model_exec_timer);    

#ifdef MODEL_PROFILING
        t_end = mdaq_profile_read_timer32(); 
        mdaq_profile_save( t_end - t_begin,0);
#endif
        /* increment execution timer */ 
        model_exec_timer += MODEL_TSAMP;
    }
    else
    {
        /* call model end only once */ 
        if(!end_called)
        {
#ifdef MODEL_PROFILING
        t_begin = mdaq_profile_read_timer32(); 
#endif 
            NAME(MODEL, _end)();        

#ifdef MODEL_PROFILING
        t_end = mdaq_profile_read_timer32(); 
        mdaq_profile_save( t_end - t_begin,1);
#endif

            end_called = 1; 

        }
    }
}

