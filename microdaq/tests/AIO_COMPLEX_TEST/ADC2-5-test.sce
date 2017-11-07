clc;
mdaqClose();
if exists("mdaq_ao_test") == 0 then
path = get_absolute_file_path("ADC2-5-test.sce");
exec(path + "\mdaq_aio_test_utils.sci");
end 

SCRIPT_MODE = 0;
SIM_MODE = 1;
DSP_MODE = 2;

// Analog Output Test01 - "AO Ranges"
last_channel = 8;

aoData  = (ones(1, last_channel)*7);
channels    = 1:last_channel;
aoRange = [-10,10];
aiRange = [-10,10];
aiMode  = %F;
treshold = 0.1;
refData = aoData;

name = "Test01: AI Ranges - -10 to +10";
mprintf("\n"+name+"\n");
mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)

name = "Test02: AI Ranges - -5 to +5"
aiRange = [-5,5];
refData = (ones(1, last_channel)*5);
mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)

name = "Test03: AI Ranges - -2 to +2"
aiRange = [-2,2];
refData = (ones(1, last_channel)*2);
mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)

name = "Test04: AI Ranges - -1 to +1"
aiRange = [-1,1];
refData = (ones(1, last_channel)*1);
mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)


