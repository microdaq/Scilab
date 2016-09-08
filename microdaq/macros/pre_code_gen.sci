function [ok,out]=pre_code_gen(scs_m)
    global %microdaq
    %microdaq.private.mdaq_signal_id = [];
    reset_mdaq_blk_idx();
    
    ok = %t;

    // scan_mdaq_block will fill mdaq_signal_id
    // with signal ID from whole scheme
    out = scan_mdaq_blocks(scs_m);
    size_unique_signal_id = size(unique(%microdaq.private.mdaq_signal_id));
    size_signal_id = size(%microdaq.private.mdaq_signal_id);
    if size_unique_signal_id(2) <> size_signal_id(2) then
        ok = %f;
        message("ERROR: Scheme contains two or more same SIGNAL IDs!");
    end

    %microdaq.private.mdaq_signal_id = [];
    reset_mdaq_blk_idx();
endfunction
