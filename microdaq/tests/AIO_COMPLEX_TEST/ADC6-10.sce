clc;
mdaqClose();
//mdaqHWInfo();

if exists("mdaq_ao_test") == 0 then
    exec(mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\mdaq_aio_test_utils.sci");
end 

exec(mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\test_defines.sce")



// AI RANGES 

mprintf("------ TESTING ADC0%d / DAC0%d config -------", ADC_ID, DAC_ID)

// --- MACROS - ERROR CHECKING  ----

//common errors 
assert_checkerror("mdaqAIRead(1, [-5.0 10], %F)", "Unsupported range")
assert_checkerror("mdaqAIRead([1 2 3 4], [-10.24 10.24], [%F %T])", "Mode vector should match selected AI channels!")

assert_checkerror("mdaqAOWrite(1, [0 20], 1)", "Unsupported range")
assert_checkerror("mdaqAOWrite(1:18, [0 5], 1:18)", "Undefined error") // BUG                     
assert_checkerror("mdaqAOWrite([1 2], [0 5], 1:5)", "Wrong data for selected AO channels") 


select ADC_ID
case 6 
assert_checkerror("mdaqAIRead(1:9, [-10.24 10.24], %F)", "Wrong AI channel selected!")
assert_checkerror("mdaqAIScanInit(1, [-10.24 10.24], %F, 500001, 1)", "AI scan frequency out of range") 

case 7
assert_checkerror("mdaqAIRead(1:9, [-10.24 10.24], %F)", "Wrong AI channel selected!")
assert_checkerror("mdaqAIScanInit(1, [-10.24 10.24], %F, 1000001, 1)", "AI scan frequency out of range") 

case 8
assert_checkerror("mdaqAIRead(1:17, [-10.24 10.24], %F)", "Wrong AI channel selected!")
assert_checkerror("mdaqAIScanInit(1, [-10.24 10.24], %F, 500001, 1)", "AI scan frequency out of range") 

case 9
assert_checkerror("mdaqAIRead(1:17, [-10.24 10.24], %F)", "Wrong AI channel selected!")
assert_checkerror("mdaqAIScanInit(1, [-10.24 10.24], %F, 1000001, 1)", "AI scan frequency out of range") 

case 10
assert_checkerror("mdaqAIScanInit(1, [-10.24 10.24], %F, 2000001, 1)", "AI scan frequency out of range") 

end

// --- MACROS | SIMULATION | DSP SIMPLE ----
last_channel = 8;
select ADC_ID
    case 6 
        last_channel = 8;
    case 7
        last_channel = 8;
    case 8
        last_channel = 16;
    case 9
        last_channel = 16;
    case 10
        last_channel = 8;
end

//name = "Test01 SUPER SIMPLE: One channel "
//aoRange = AO10;
//aiRange = AI10_24;
//aoData = 5;
//channels = 1;
//aiMode  = %F;
//refData = aoData;
//mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)

//Analog Output Test01 - "AO Ranges"
//aoData  = (ones(1, last_channel)*7);
//channels    = 1:last_channel;
//aoRange = AO10;
//aiRange = AI10_24;
//aiMode  = %F;
//treshold = 0.15;
//refData = aoData;
//
//name = "Test01: AI Ranges - -10.24 to +10.24";
//mprintf("\n"+name+"\n");
//mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)
//
//name = "Test02: AI Ranges - -5.12 to +5.12"
//aiRange = AI5_12;
//refData = (ones(1, last_channel)*5.12);
//mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)
//
//name = "Test03: AI Ranges - -2.56 to +2.56"
//aiRange = AI2_56;
//refData = (ones(1, last_channel)*2.56);
//mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)
//
//name = "Test04: AI Ranges - -1.28 to +1.28"
//aiRange = AI1_28;
//refData = (ones(1, last_channel)*1.28);
//mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)
//
//name = "Test05: AI Ranges - -0.64 to +0.64"
//aiRange = AI0_64;
//refData = (ones(1, last_channel)*0.64);
//mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)
//
//input("Press any key.");
//
//// --- MACROS | SIMULATION | DSP ADVANCED ----
//aoData   = [ones(1, 8)*(-10) ones(1, 8)*(10)];
//aoData   = aoData(1:last_channel);
//
//channels = 1:last_channel;
//aoRange  = AO10;
//aiRange  = [AI10_24; AI5_12; AI2_56; AI1_28; AI0_64; AI10_24; AI5_12; AI2_56; AI1_28; AI0_64; AI10_24; AI5_12; AI2_56; AI1_28; AI0_64; AI10_24];
//aiRange  = aiRange(1:last_channel, 1:2);
//aiMode   = %F;
//treshold = 0.15;
//refData  = [-10 -5.12 -2.56 -1.28 -0.64 -10 -5.12 -2.56 1.28 0.64 10 5.12 2.56 1.28 0.64 10];
//refData  = refData(1:last_channel);
//
//
//name = "Test06: AI Ranges - MIX"
//mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)

name = "Test07: AI Mode";
aoData  = [-7:8];
aoData   = aoData(1:last_channel);
AOchannels    = 1:last_channel;
AIchannels    = 1:last_channel/2;
aoRange = [AO10];
aiRange = [AI10_24];
aiMode  = %T;
refData = [ones(1, last_channel/2)*(-1)];
for i=2:2:last_channel/2
    refData(i) = refData(i) * (-1);
end


mdaq_ao_test(AOchannels, aoRange, aoData, SCRIPT_MODE);

r1 = validate_test_val(mdaq_ai_test(AIchannels, aiRange, aiMode, SCRIPT_MODE), refData, treshold, "macro test");
r2 = validate_test_val(mdaq_ai_test(AIchannels, aiRange, aiMode, SIM_MODE), refData, treshold, "sim test");
r3 = validate_test_val(mdaq_ai_test(AIchannels, aiRange, aiMode, DSP_MODE), refData, treshold, "DSP test");
mprintf("\n\n---------- REPORT: "+name+" ----------")
mprintf(r1); mprintf(r2); mprintf(r3);
mprintf("----------------------------------------------\n\n")
