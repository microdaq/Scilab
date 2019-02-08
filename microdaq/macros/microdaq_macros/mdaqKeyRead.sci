function state = mdaqKeyRead(arg1, arg2)
    state = []; 
    
    if argn(2) == 1 then
        func_key = arg1; 
    end
    
    if argn(2) == 2 then
        link_id = arg1;   
        func_key = arg2; 

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    if argn(2) > 2 | argn(2) < 1 | func_key > 2 | func_key < 1 then
        mprintf("Description:\n");
        mprintf("\tReads MicroDAQ function key state\n");
        mprintf("Usage:\n");
        mprintf("\tstate = mdaqKeyRead(linkID, functionKey)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tfunctionKey - function key number (1|2)\n");
        return;
    end
    
    if argn(2) == 1 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
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
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
