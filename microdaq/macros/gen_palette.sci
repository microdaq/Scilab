function [res] = gen_palette(tmp_dir)
res=[];

pal_handle = list();
pal_counter = 19;

pal_handle(1) = xcosPal('MicroDAQ');
pal_handle(2) = xcosPal('Commonly Used Blocks');
pal_handle(3) = xcosPal('Continuous time systems');
pal_handle(4) = xcosPal('Discontinuities');
pal_handle(5) = xcosPal('Discrete time systems');
pal_handle(6) = xcosPal('Lookup Tables');
pal_handle(7) = xcosPal('Event handling');
pal_handle(8) = xcosPal('Mathematical Operations');
pal_handle(9) = xcosPal('Matrix');
pal_handle(10) = xcosPal('Integer');
pal_handle(11) = xcosPal('Port & Subsystem');
pal_handle(12) = xcosPal('Zero crossing detection');
pal_handle(13) = xcosPal('Signal Routing');
pal_handle(14) = xcosPal('Signal Processing');
pal_handle(15) = xcosPal('Implicit');
pal_handle(16) = xcosPal('Annotations');
pal_handle(17) = xcosPal('Sinks');
pal_handle(18) = xcosPal('Sources');
pal_handle(19) = xcosPal('User-Defined Functions');

//---- FIXED BLOCKS ----

//MicroDAQ
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_adc');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_dac');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_dio_config');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_dio_get');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_dio_set');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_encoder');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_func_key');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_led');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_mem_read');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_mem_write');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_pru_reg_get');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_pru_reg_set');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_pwm');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_signal');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_param');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_tcp_recv');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_tcp_send');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_udp_recv');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_udp_send');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_to_file');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_uart_config');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_uart_read');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_uart_write');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_webscope');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_time');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_profiler');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_stop');
pal_handle(1) = xcosPalAddBlock(pal_handle(1), 'mdaq_setup');

//Commonly Used Blocks
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'mdaq_setup');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'mdaq_signal');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'mdaq_adc');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'mdaq_dac');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'CONST_m');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'MUX');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'DEMUX');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'CLOCK_c');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'IFTHEL_f');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'CSCOPE');
pal_handle(2) = xcosPalAddBlock(pal_handle(2), 'TOWS_c');

//event_handling
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'CLOCK_c');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'SampleCLK');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'ANDBLK');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'CLKFROM');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'CLKGOTO');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'CLKOUTV_f');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'CLKSOMV_f');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'EDGE_TRIGGER');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'ESELECT_f');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'EVTGEN_f');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'Extract_Activation');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'M_freq');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'MCLOCK_f');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'MFCLCK_f');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'freq_div');
pal_handle(7) = xcosPalAddBlock(pal_handle(7), 'IFTHEL_f');

//Port & Subsystem
pal_handle(11) = xcosPalAddBlock(pal_handle(11), 'CLKINV_f');
pal_handle(11) = xcosPalAddBlock(pal_handle(11), 'CLKOUTV_f');
pal_handle(11) = xcosPalAddBlock(pal_handle(11), 'SUPER_f');

//signal_routing
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'DEMUX');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'MUX');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'FROM');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'GOTO');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'CLKFROM');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'CLKGOTO');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'ISELECT_m');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'M_SWITCH');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'SELECT_m');
pal_handle(13) = xcosPalAddBlock(pal_handle(13), 'SWITCH2_m');

//sinks
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'AFFICH_m');
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'CLKOUTV_f');
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'CSCOPE');
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'CMSCOPE');
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'OUT_f');
pal_handle(17) = xcosPalAddBlock(pal_handle(17), 'TOWS_c');

//sources
pal_handle(18) = xcosPalAddBlock(pal_handle(18), 'CLKINV_f');
pal_handle(18) = xcosPalAddBlock(pal_handle(18), 'CLOCK_c');
pal_handle(18) = xcosPalAddBlock(pal_handle(18), 'CONST_m');
pal_handle(18) = xcosPalAddBlock(pal_handle(18), 'CONST');
pal_handle(18) = xcosPalAddBlock(pal_handle(18), 'mdaq_sinus');
pal_handle(18) = xcosPalAddBlock(pal_handle(18), 'mdaq_square');
pal_handle(18) = xcosPalAddBlock(pal_handle(18), 'mdaq_step');

//User-Defined Functions
pal_handle(19) = xcosPalAddBlock(pal_handle(19), 'SUPER_f');

//---- GENERATED BLOCKS ----
pal_handle(5) = xcosPalAddBlock(pal_handle(5), 'mdaq_pid_z');
pal_handle(5) = xcosPalAddBlock(pal_handle(5), 'DLR');
pal_handle(5) = xcosPalAddBlock(pal_handle(5), 'DLSS');
pal_handle(5) = xcosPalAddBlock(pal_handle(5), 'DOLLAR');
pal_handle(5) = xcosPalAddBlock(pal_handle(5), 'DOLLAR_m');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'SATURATION');
pal_handle(5) = xcosPalAddBlock(pal_handle(5), 'REGISTER');
pal_handle(5) = xcosPalAddBlock(pal_handle(5), 'SAMPHOLD_m');
pal_handle(5) = xcosPalAddBlock(pal_handle(5), 'TCLSS');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'ABS_VALUE');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'BIGSOM_f');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'EXPBLK_m');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'GAINBLK');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'MAXMIN');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'PROD_f');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'PRODUCT');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'SIGNUM');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'SQRT');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'SUM_f');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'SUMMATION');
pal_handle(8) = xcosPalAddBlock(pal_handle(8), 'TrigFun');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'CLSS');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'DERIV');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'INTEGRAL_m');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'TCLSS');
pal_handle(3) = xcosPalAddBlock(pal_handle(3), 'VARIABLE_DELAY');
pal_handle(14) = xcosPalAddBlock(pal_handle(14), 'SAMPHOLD_m');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'CUMSUM');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'EXTRACT');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'MATCATV');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'MATMAGPHI');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'MATMUL');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'MATRESH');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'MATSUM');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'SQRT');
pal_handle(9) = xcosPalAddBlock(pal_handle(9), 'SUBMAT');
pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'BITCLEAR');
pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'BITSET');
pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'DLATCH');
pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'EXTRACTBITS');
pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'INTMUL');
pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'JKFLIPFLOP');

// pal_handle(10) = xcosPalAddBlock(pal_handle(10), 'LOGIC');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'BACKLASH');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'DEADBAND');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'HYSTHERESIS');
pal_handle(4) = xcosPalAddBlock(pal_handle(4), 'RATELIMITER');

//Add palettes 
for i=1:pal_counter
     xcosPalAdd(pal_handle(i), "MicroDAQ");
     if i < 10 then 
         idx = "0"+string(i);
     else
         idx = string(i);
     end
     xcosPalExport(pal_handle(i), tmp_dir+filesep()+idx+".sod");
end
res=0;

endfunction
