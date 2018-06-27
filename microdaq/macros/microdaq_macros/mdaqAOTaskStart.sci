function mdaqAOTaskStart(arg1)
    if argn(2) == 1 then
        link_id = arg1;   
        if link_id < 0 then
            error("Invalid link ID!")
        end
    end
    
    if argn(2) > 1 then
        mprintf("Description:\n");
        mprintf("\tStarts AO signal generation\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqAOScan(linkID, timeout)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        return;
    end
    
    if argn(2) == 0 then
        link_id = mdaqOpen();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    result = call("sci_mlink_ao_scan",..
                    link_id, 1, "i",..
                    0, 2, "i",..
                "out",..
                    [1, 1], 3, "i");

    if argn(2) == 0 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end

endfunction
