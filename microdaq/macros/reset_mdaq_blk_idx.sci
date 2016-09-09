function reset_mdaq_blk_idx()
     global %microdaq;
     
    //reset adc, dac, to file, mem write, mem read
    //webscope, udpsend block counters 
    %microdaq.private.dac_idx = 0;
    %microdaq.private.adc_idx = 0;
    %microdaq.private.mem_write_idx = 0;
    %microdaq.private.mem_read_idx = 0;
    %microdaq.private.to_file_idx = 0;
    %microdaq.private.webscope_idx = 0;
    %microdaq.private.udpsend_idx = 0;
endfunction 
