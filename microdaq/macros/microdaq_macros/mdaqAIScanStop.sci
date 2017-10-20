function mdaqAIScanStop()
    result = call("sci_mlink_ai_scan_stop", "out", [1, 1], 1, "i");
    if  result < 0  then
        mdaq_error(result) 
    end
endfunction
