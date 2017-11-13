// ------ CONSTATNTS ------
global %microdaq;
mprintf("Loading test defines...\n")
AI10_24 = [-10.24 10.24];
AI5_12 = [-5.12 5.12];
AI2_56 = [-2.56 2.56];
AI1_28 = [-1.28 1.28];
AI0_64 = [-0.64 0.64];

AO10 = [-10 10];
AO5  = [-5 5];
AO10_0 = [0 10];
AO5_0 = [0 5];

ADC_ID = %microdaq.private.adc_info.id;
DAC_ID = %microdaq.private.dac_info.id;

SCRIPT_MODE = 0;
SIM_MODE = 1;
DSP_MODE = 2;
