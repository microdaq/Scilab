function reset_mdaq_blk_idx()
    global %microdaq;
     
    %microdaq.private.dac_idx = 0;
    %microdaq.private.adc_idx = 0;
    %microdaq.private.mem_write_idx = 0;
    %microdaq.private.mem_read_idx = 0;
    %microdaq.private.to_file_idx = 0;
    %microdaq.private.webscope_idx = 0;
    %microdaq.private.udpsend_idx = 0;
    %microdaq.private.udprecv_idx = 0;
    %microdaq.private.tcpsend_idx = 0;
    %microdaq.private.tcprecv_idx = 0;
endfunction 
