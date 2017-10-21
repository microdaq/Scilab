clc;
mdaqClose();
if exists("mdaq_ao_test") == 0 then
exec(mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\mdaq_aio_test_utils.sci");
end 

SCRIPT_MODE = 0;
SIM_MODE = 1;
DSP_MODE = 2;

// AI RANGES 
AI10_24 = [-10.24 10.24];
AI5_12 = [-5.12 5.12];
AI2_56 = [-2.56 2.56];
AI1_28 = [-1.28 1.28];
AI0_64 = [-0.64 0.64];

AO10 = [-10 10];
AO5  = [-5 5];
AO10_0 = [0 10];
AO5_0 = [0 5];


// Analog Output Test01 - "AO Ranges"
//TITLE = "Test01: AO Ranges";
//mprintf("\n"+TITLE+"\n");
//AO_DATA  = [ones(1, 8)*(-10) ones(1, 8)*(10)]';
//AO_CH    = 1:16;
//AI_CH    = 1:16;
//AO_RANGE = [AO10; AO5; AO10; AO5; AO10; AO5; AO10; AO5; AO10; AO5; AO10; AO5; AO10; AO5; AO10; AO5];
//AI_RANGE = [AI10_24];
//AI_MODE  = %F;
//ERR      = 0.1;
//REF_OUT  = [-10 -5 -10 -5 -10 -5 -10 -5     10 5 10 5 10 5 10 5];
//
//
//mdaq_ao_test(AO_CH, AO_RANGE, AO_DATA, SCRIPT_MODE);
//r1 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, SCRIPT_MODE), REF_OUT, ERR, "macro test");
//
//mdaq_ao_test(AO_CH, AO_RANGE, AO_DATA, SIM_MODE);
//r2 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, SCRIPT_MODE), REF_OUT, ERR, "sim test");
//
//mdaq_ao_test(AO_CH, AO_RANGE, AO_DATA, DSP_MODE);
//r3 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, SCRIPT_MODE), REF_OUT, ERR, "DSP test");
//mprintf("\n\n---------- REPORT: "+TITLE+" ----------")
//mprintf(r1); mprintf(r2); mprintf(r3);
//mprintf("----------------------------------------------\n\n")
//input("Press any key to run next test.");
//
//
////Analog Output Test01 - "AI Ranges"
TITLE = "Test02: AI Ranges";
mprintf("\n"+TITLE+"\n");
AO_DATA  = [ones(1, 8)*(-10) ones(1, 8)*(10)];
AO_CH    = 1:16;
AI_CH    = 1:16;
AO_RANGE = [AO10];
AI_RANGE = [AI10_24; AI5_12; AI2_56; AI1_28; AI0_64; AI10_24; AI5_12; AI2_56; AI1_28; AI0_64; AI10_24; AI5_12; AI2_56; AI1_28; AI0_64; AI10_24];
AI_MODE  = %F;
ERR      = 0.02;
REF_OUT  = [-10 -5.12 -2.56 -1.28 -0.64 -10 -5.12 -2.56 1.28 0.64 10 5.12 2.56 1.28 0.64 10];


mdaq_ao_test(AO_CH, AO_RANGE, AO_DATA, SCRIPT_MODE);

r1 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, SCRIPT_MODE), REF_OUT, ERR, "macro test");
r2 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, SIM_MODE), REF_OUT, ERR, "sim test");
r3 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, DSP_MODE), REF_OUT, ERR, "DSP test");
mprintf("\n\n---------- REPORT: "+TITLE+" ----------")
mprintf(r1); mprintf(r2); mprintf(r3);
mprintf("----------------------------------------------\n\n")
//input("Press any key to run next test.");
//
//Analog Output Test03 - "AI MODE"
//TITLE = "Test03: AI Mode";
//mprintf("\n"+TITLE+"\n");
//AO_DATA  = [-7:8];
//AO_CH    = 1:16;
//AI_CH    = 1:8;
//AO_RANGE = [AO10];
//AI_RANGE = [AI10_24];
//AI_MODE  = %T;
//
//ERR      = 0.02;
//
//REF_OUT = [];
//
//for i=1:8
//    if modulo(i, 2) == 1
//        REF_OUT  = [REF_OUT (AO_DATA(i*2-1)-AO_DATA(i*2))];
//    else
//        REF_OUT  = [REF_OUT (AO_DATA(i*2)-AO_DATA(i*2-1))];
//    end
//end
//
//mdaq_ao_test(AO_CH, AO_RANGE, AO_DATA, SCRIPT_MODE);
//
//r1 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, SCRIPT_MODE), REF_OUT, ERR, "macro test");
//r2 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, SIM_MODE), REF_OUT, ERR, "sim test");
//r3 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, DSP_MODE), REF_OUT, ERR, "DSP test");
//mprintf("\n\n---------- REPORT: "+TITLE+" ----------")
//mprintf(r1); mprintf(r2); mprintf(r3);
//mprintf("----------------------------------------------\n\n")

//Analog Output Test04 - "AI MIX MODE"
//TITLE = "Test04: AI MIX Mode";
//mprintf("\n"+TITLE+"\n");
//AO_DATA  = [-7:8];
//AO_CH    = 1:16;
//AI_CH    = [1 3 5 7 9 10 11 12 13 14 15 16];
//AO_RANGE = [AO10];
//AI_RANGE = [AI10_24];
//AI_MODE  = [%T %T %T %T %F %F %F %F %F %F %F %F];
//
//ERR      = 0.02;
//
//REF_OUT = [-1 -1 -1 -1 1:8];
//
//mdaq_ao_test(AO_CH, AO_RANGE, AO_DATA, SCRIPT_MODE);
//
//r1 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, SCRIPT_MODE), REF_OUT, ERR, "macro test");
//r2 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, SIM_MODE), REF_OUT, ERR, "sim test");
//r3 = validate_test_val(mdaq_ai_test(AI_CH, AI_RANGE, AI_MODE, DSP_MODE), REF_OUT, ERR, "DSP test");
//mprintf("\n\n---------- REPORT: "+TITLE+" ----------")
//mprintf(r1); mprintf(r2); mprintf(r3);
//mprintf("----------------------------------------------\n\n")




