function obj = perform_scan(scs_m)
    reset_mdaq_blk_idx();
    obj=scan_mdaqBlocks(scs_m);
endfunction
