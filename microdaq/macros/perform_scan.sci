function obj = perform_scan(scs_m)
    reset_mdaq_blk_idx();
    obj=scan_mdaq_blocks(scs_m);
endfunction
