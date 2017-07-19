function state = mdaq_key_read(arg1, arg2)
    state = -1; 
    
    if argn(2) == 1 then
        func_key = arg1; 
    end
    
    if argn(2) == 2 then
        link_id = arg1;   
        func_key = arg2; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 2 | argn(2) < 1 | func_key > 2 | func_key < 1 then
        mprintf("Description:\n");
        mprintf("\tReads MicroDAQ function buttons F1 and F2\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_key_read(link_id, key);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tencoder - function key number (1 or 2)\n");
        return;
    end
    
    if argn(2) == 1 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end

    result = [];
    [state result] = call("sci_mlink_func_key_get",..
            link_id, 1, "i",..
            func_key, 2, "i",..
        "out",..
            [1, 1], 3, "i",..
            [1, 1], 4, "i");
            
    if state <> 0 then
        state = %T;
    else
        state = %F; 
    end
    
    if argn(2) == 1 then
        mdaq_close(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
