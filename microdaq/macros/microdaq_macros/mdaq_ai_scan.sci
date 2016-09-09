function [data, result] = mdaq_ai_scan(arg1, arg2, arg3)
    link_id = -1; 
    data = [];
    result = [];
       
    ch_count = call("sci_mlink_ai_scan_get_ch_count", "out", [1, 1], 1, "i");
    if ch_count < 0 | ch_count > 16 then
        disp("ch_count ERROR");
        disp(ch_count);
        return; 
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
        mprintf("\tStarts and reads scan data\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ai_scan(link_id, scan_count, blocking);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tscan_count - number of scans to read\n");
        mprintf("\tblocking - blocking or non-blocking read (%%T/%%F)\n");
        return;
    end
    
    if blocking == %T then
        blocking = 1;
    else 
        blocking = 0; 
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
            error(mdaq_error(result), 10000 + abs(result))
        end
        data = [];            
    end

    data = data';    
    result = round(result / ch_count); 
    
    if result < scan_count then
        data = data(1:result,:)
    end
endfunction
