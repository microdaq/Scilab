function obj = perform_scan(scs_m)
    global %microdaq;
    //reset adc, dac, to file, mem write, mem read block counters 
    %microdaq.private.mdaq_dac_idx = 0;
    %microdaq.private.mdaq_adc_idx = 0;
    %microdaq.private.mem_write_idx = 0;
    %microdaq.private.mem_read_idx = 0;
    %microdaq.private.to_file_idx = 0;
    
    obj=scan_mdaq_blocks(scs_m);
endfunction
