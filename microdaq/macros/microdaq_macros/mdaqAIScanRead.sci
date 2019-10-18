function [data, result] = mdaqAIScanRead(arg1, arg2, arg3)
    link_id = -1; 
    data = [];
    result = [];
    
    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tReads acquired data\n");
        mprintf("Usage:\n");
        mprintf("\t[data, result] = mdaqAIScanRead(linkID, count, timeout)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tcount - number of scans to read\n");
        mprintf("\ttimeout - amount of time in seconds (-1 - wait indefinitely)\n");
        return;
    end

    ch_count = call("sci_mlink_ai_scan_get_ch_count", "out", [1, 1], 1, "i");
    if ch_count < 1 | ch_count > 16 then
        error("Data acquisition not initialized");
    end
    
    if argn(2) == 2 then;  
        scan_count = arg1; 
        timeout = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1; 
        scan_count = arg2; 
        timeout = arg3;

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end
    
    if type(timeout) == 4 then
        error("isBlocking boolean argument is obsolete, provide timeout in seconds instead"); 
    end
    
    if timeout < 0 then
        timeout = -1;
    end
    
    if timeout > 0 then
        timeout = timeout * 1000; 
    end
    
    if scan_count < 0 then
        error("scanCount parameter has to be equal or grater than 0");
    end
    
    if argn(2) == 2 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end
    
    [ data result ] = call("sci_mlink_ai_scan",..
                link_id, 1, "i", ..
                scan_count, 3, "i",..
                timeout, 4, "i",..
            "out",..
                [ch_count, scan_count], 2, "d",.. 
                [1, 1], 5, "i");

    if argn(2) == 2 then
        mdaqClose(link_id);
    end

    if result < 0 then
        error(mdaq_error2(result), 10000 + abs(result))         
    end

    data = data';    
    result = round(result / ch_count); 
    
    if result < scan_count then
        data = data(1:result,:)
    end
endfunction
