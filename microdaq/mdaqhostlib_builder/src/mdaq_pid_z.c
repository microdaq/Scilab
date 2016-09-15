/* Generated with MicroDAQ toolbox ver: 1.1. */
#include "scicos_block4.h"
#include "PID_z.h"

extern double get_scicos_time( void );

/* This function will executed once at the beginning of model execution */
static void init(scicos_block *block)
{
    /* Block parameters */
    double *params = GetRparPtrs(block);

    /* param size = 1 */
    double filter_coefficient = params[0];
    /* param size = 1 */
    double upper_sat_limit = params[1];
    /* param size = 1 */
    double lower_sat_limit = params[2];
    /* param size = 1 */
    double back_calculation_kb = params[3];
    /* param size = 1 */
    double tracking_kt = params[4];
    /* param size = 1 */
    double sample_time = params[5];
	
    /* Add block init code here */
	PID_DATA_T *pid_data = malloc(sizeof(PID_DATA_T));
	memset( (void*)pid_data, 0x0, sizeof(PID_DATA_T) );

    PID_z_Init(&pid_data->localDW, &pid_data->localP);

    pid_data->localP.FilterCoefficient_Gain = filter_coefficient;
	pid_data->localP.Saturation_UpperSat = upper_sat_limit;
    pid_data->localP.Saturation_LowerSat = lower_sat_limit;
	pid_data->localP.Kb_Gain = back_calculation_kb;
    pid_data->localP.Kt_Gain = tracking_kt;
	pid_data->localP.Filter_gainval =  sample_time;
    
    pid_data->localP.Integrator_gainval = sample_time;

    pid_data->localP.Filter_IC = 0.0; 
    pid_data->localP.Integrator_IC =  0.0;
	
	*block->work = (void*)pid_data;
}

/* This function will be executed on every model step */
static void inout(scicos_block *block)
{
    /* Block input ports */
    double *u1 = GetRealInPortPtrs(block,1);
    int u1_size = GetInPortRows(block,1);    /* u1_size = 1 */

    double *u2 = GetRealInPortPtrs(block,2);
    int u2_size = GetInPortRows(block,2);    /* u2_size = 1 */

    double *u3 = GetRealInPortPtrs(block,3);
    int u3_size = GetInPortRows(block,3);    /* u3_size = 3 */

    /* Block output ports */
    double *y1 = GetRealOutPortPtrs(block,1);
    int y1_size = GetOutPortRows(block,1);    /* y1_size = 1 */

    /* Add block code here (executed every model step) */
	PID_DATA_T *pid_data = (PID_DATA_T*)*(block->work);
	
    pid_data->localP.ProportionalGain_Gain = u3[0];
	pid_data->localP.IntegralGain_Gain     = u3[1];
	pid_data->localP.DerivativeGain_Gain   = u3[2];  

    PID_z(*u1, *u2, &pid_data->localB , &pid_data->localDW, &pid_data->localP);
    *y1 = pid_data->localB.Saturation;
}

/* This function will be executed once at the end of model execution (only in Ext mode) */
static void end(scicos_block *block)
{
  
}

void mdaq_pid_z(scicos_block *block,int flag)
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
