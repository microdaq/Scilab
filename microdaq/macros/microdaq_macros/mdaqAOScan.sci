function mdaqAOScan(arg1)

    if argn(2) == 1 then
        link_id = arg1;   
        if link_id < 0 then
            error("Invalid connection id!")
        end
    end
    
    if argn(2) > 1 then
        mprintf("Description:\n");
        mprintf("\tStarts analog signal generation\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqAOScan(linkID)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        return;
    end
    
    if argn(2) == 0 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
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
