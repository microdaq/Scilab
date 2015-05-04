function [res] = gen_palette()
res=[];

pal_handle = list();
pal_counter = 18;
pal_handle(1) = xcosPal('Commonly Used Blocks');
pal_handle(2) = xcosPal('Continuous time systems');
pal_handle(3) = xcosPal('Discontinuities');
pal_handle(4) = xcosPal('Discrete time systems');
pal_handle(5) = xcosPal('Lookup Tables');
pal_handle(6) = xcosPal('Event handling');
pal_handle(7) = xcosPal('Mathematical Operations');
pal_handle(8) = xcosPal('Matrix');
pal_handle(9) = xcosPal('Integer');
pal_handle(10) = xcosPal('Port & Subsystem');
pal_handle(11) = xcosPal('Zero crossing detection');
pal_handle(12) = xcosPal('Signal Routing');
pal_handle(13) = xcosPal('Signal Processing');
pal_handle(14) = xcosPal('Implicit');
pal_handle(15) = xcosPal('Annotations');
pal_handle(16) = xcosPal('Sinks');
pal_handle(17) = xcosPal('Sources');
pal_handle(18) = xcosPal('User-Defined Functions');

//---- FIXED BLOCKS ----
//Commonly Used Blocks
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_setup');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_signal');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_sinus');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_square');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_adc');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_dac');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'CONST_m');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'MUX');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'DEMUX');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'CLOCK_c');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'CSCOPE');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'TOWS_c');

//event_handling
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'CLOCK_c');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'SampleCLK');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'ANDBLK');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'CLKFROM');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'CLKGOTO');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'CLKOUTV_f');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'CLKSOMV_f');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'EDGE_TRIGGER');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'ESELECT_f');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'EVTGEN_f');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'Extract_Activation');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'M_freq');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'MCLOCK_f');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'MFCLCK_f');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'freq_div');
pal_handle(6) = xcosPalAddBlock(pal_handle(6), 'IFTHEL_f');

//Port & Subsystem
pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'CLKINV_f');
pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'CLKOUTV_f');
pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'SUPER_f');
//signal_routing
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'DEMUX');
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'MUX');
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'FROM');
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'GOTO');
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'CLKFROM');
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'CLKGOTO');
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'ISELECT_m');
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'M_SWITCH');
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'SELECT_m');
pal_handle(12) = xcosPalAddBlock(pal_handle(12), 'SWITCH2_m');
//sinks
pal_handle(16) = xcosPalAddBlock(pal_handle(16), 'AFFICH_m');
pal_handle(16) = xcosPalAddBlock(pal_handle(16), 'CLKOUTV_f');
pal_handle(16) = xcosPalAddBlock(pal_handle(16), 'CSCOPE');
pal_handle(16) = xcosPalAddBlock(pal_handle(16), 'CMSCOPE');
pal_handle(16) = xcosPalAddBlock(pal_handle(16), 'OUT_f');
pal_handle(16) = xcosPalAddBlock(pal_handle(16), 'TOWS_c');
//sources
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'CLKINV_f');
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'CLOCK_c');
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'CONST_m');
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'CONST');
//User-Defined Functions
pal_handle(18) = xcosPalAddBlock(pal_handle(18), 'SUPER_f');

//---- GENERATED BLOCKS ----
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'DLR');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'DLSS');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'DOLLAR');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'DOLLAR_m');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'SATURATION');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'REGISTER');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'SAMPHOLD_m');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'TCLSS');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'ABS_VALUE');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'BIGSOM_f');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'EXPBLK_m');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'GAINBLK');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'MAXMIN');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'PROD_f');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'PRODUCT');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'SIGNUM');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'SQRT');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'SUM_f');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'SUMMATION');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'TrigFun');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'CLSS');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'DERIV');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'INTEGRAL_m');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'TCLSS');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'VARIABLE_DELAY');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'SAMPHOLD_m');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'CUMSUM');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'EXTRACT');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'MATCATV');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'MATMAGPHI');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'MATMUL');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'MATRESH');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'MATSUM');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'SQRT');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'SUBMAT');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'BITCLEAR');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'BITSET');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'DLATCH');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'EXTRACTBITS');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'INTMUL');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'JKFLIPFLOP');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'LOGIC');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'BACKLASH');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'DEADBAND');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'HYSTHERESIS');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'RATELIMITER');

//Add palettes 
for i=1:pal_counter
     xcosPalAdd(pal_handle(i),'MicroDAQ')
end
res=0;

endfunction
