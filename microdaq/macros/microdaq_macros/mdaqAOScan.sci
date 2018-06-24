function mdaqAOScan(arg1, arg2)
   if argn(2) == 1 then
        timeout = arg1; 
    end
    
    if argn(2) == 2 then
        link_id = arg1;   
        timeout = arg2; 

        if link_id < 0 then
            error("Invalid link ID!")
        end
    end
    
    if argn(2) > 2 | argn(2) < 1 then
        mprintf("Description:\n");
        mprintf("\tStarts AO signal generation\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqAOScan(linkID, timeout)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\ttimeout - amount of time in seconds to wait until generation\n");
        mprintf("\t\t  is done (-1 - wait indefinitely, 0 - run in background)\n");
        return;
    end
    
    if argn(2) == 1 then
        link_id = mdaqOpen();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    if timeout < 0 then
        timeout = -1;
    end
    
    if timeout > 0 then
        timeout = timeout * 1000; 
    end
    
    result = call("sci_mlink_ao_scan",..
                    link_id, 1, "i",..
                    timeout, 2, "i",..
                "out",..
                    [1, 1], 3, "i");

    if argn(2) == 1 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
