function mdaq_ao_data_queue(arg1, arg2, arg3)
    global %microdaq;
    link_id = -1; 

    if argn(2) == 2 then
        data = arg1; 
        blocking = arg2;
    end
    
    if argn(2) == 3 then
        link_id = arg1; 
        data = arg2; 
        blocking = arg3;
        
        if link_id < 0 then
            error("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tQueues AO channel data in scanning continuous mode.\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ao_data_queue(link_id, data, blocking);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tdata - AO scan data");
        disp("       blocking - blocking mode (%T-enable, %F-disable)");
        return;
    end
    
    if blocking == %T then
            blocking = 1;
    elseif blocking == %F then
            blocking = 0;
    elseif blocking > 0 then 
            blocking = 1;
    else 
            blocking = 0;
    end

    data_size = size(data, "*"); 
    ch_count = %microdaq.private.ao_scan_ch_count;
    if ch_count <> size(data, "c") then
        error("ERROR: Wrong AO scan data size or function is called before mdaq_ao_scan_init"); 
        return
    end
    
    if argn(2) == 2 then
        link_id = mdaq_open();
        if link_id < 0 then
            error("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    result = [];
    result = call("sci_mlink_ao_data_queue",..
                    link_id, 1, "i",..
                    data, 2, "d",..
                    data_size, 3, "i",..
                    blocking, 4, "i",..
                "out",..
                    [1, 1], 5, "i");

    if argn(2) == 2 then
        mdaq_close(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
