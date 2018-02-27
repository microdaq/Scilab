function [data, result] = mdaqAIScan(arg1, arg2, arg3)
    link_id = -1; 
    data = [];
    result = [];

    ch_count = call("sci_mlink_ai_scan_get_ch_count", "out", [1, 1], 1, "i");
    if ch_count < 1 | ch_count > 16 then
        error("AI scan not initialized");
    end
    
    if argn(2) == 2 then;  
        scan_count = arg1; 
        blocking = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1; 
        scan_count = arg2; 
        blocking = arg3;


        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tStarts scanning operation and reads acquired data\n");
        mprintf("Usage:\n");
        mprintf("\t[data, result] = mdaqAIScan(linkID, scanCount, isBlocking\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tscanCount - number of scans to read, when 0 - start acquisition only\n");
        mprintf("\tisBlocking - blocking or non-blocking read (%s/%s)\n", "%T", "%F");
        return;
    end
    
    if blocking == %T then
        blocking = 1;
    else 
        blocking = 0; 
    end
    
    if scan_count < 0 then
        error("scanCount parameter has to be equal or grater than 0");
    end
    
    [ data result ] = call("sci_mlink_ai_scan",..
                scan_count, 2, "i",..
                blocking, 3, "i",..
            "out",..
                [ch_count, scan_count], 1, "d",.. 
                [1, 1], 4, "i");

    if result < 0 then
        // -91 - timeout
        if result == -91  then
            mdaq_error(result)
        else 
            error(mdaq_error2(result), 10000 + abs(result))
        end
        data = [];            
    end

    data = data';    
    result = round(result / ch_count); 
    
    if result < scan_count then
        data = data(1:result,:)
    end
endfunction
