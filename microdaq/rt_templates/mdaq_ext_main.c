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

extern void mdaq_start_rtos();
extern int mdaq_create_signal_task(void);
extern int mdaq_create_rt_task(double, void (*f)(int));

/* Real-time task */ 
void rt_task(int arg0);

volatile double model_exec_timer = 0.0; 
volatile double model_stop_flag = 0.0;
volatile double ext_mode = 1.0;
volatile double model_is_running = 0.0;
volatile int32_t model_step_cycle_cnt = 0; 

#pragma NOINIT(model_tsamp);
double model_tsamp;

#pragma NOINIT(model_duration);
double model_duration;

double get_scicos_time( void )
{
    return model_exec_timer; 
}

double get_scicos_tsamp(void)
{
    return model_tsamp;
}

double NAME(MODEL, _get_tsamp)(void)
{ 
    return model_tsamp;
}

int main()
{   

#ifdef MODEL_PROFILING
    int32_t t_begin, t_end;
#endif 
    model_is_running = 0.0;

    if(model_tsamp <= 0.0)
		model_tsamp = MODEL_TSAMP;

    if(model_duration == 0.0)
		model_duration = MODEL_DURATION;

    mdaq_create_rt_task(model_tsamp, rt_task);
    mdaq_create_signal_task();

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
    model_is_running = 1.0;

    mdaq_start_rtos();
}

/* Real-time task */ 
void rt_task(int arg0)
{
    static int end_called = 0; 

#ifdef MODEL_PROFILING
    int32_t t_begin, t_end;
#endif 

    /* This condition determine if model step/isr is executed */ 
    if( model_stop_flag == 0.0 && ( model_exec_timer <= model_duration || model_duration == -1 ))
    {

#ifdef MODEL_PROFILING
        t_begin = mdaq_profile_read_timer32(); 
#endif 

        /* Call model isr function */ 
        NAME(MODEL, _isr)(model_exec_timer);    

#ifdef MODEL_PROFILING
        t_end = mdaq_profile_read_timer32(); 
	model_step_cycle_cnt = t_end - t_begin; 
        mdaq_profile_save( t_end - t_begin,0);
#endif
        /* increment execution timer */ 
        model_exec_timer += model_tsamp;
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
            signal_task_terminate();
            end_called = 1; 
            model_is_running = 0.0;
        }
    }
}

