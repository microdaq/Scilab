function state = mdaqDIORead(arg1, arg2)
    state = -1;
    if argn(2) == 1 then
        dio = arg1; 
    end
    
    if argn(2) == 2 then
        link_id = arg1;   
        dio = arg2; 
        if link_id < 0 then
            error("Invalid link ID!")
            return;
        end
    end
    
    if argn(2) > 2 | argn(2) < 1 then
        mprintf("Description:\n");
        mprintf("\tReads DIO state\n");
        mprintf("Usage:\n");
        mprintf("\tstate = mdaqDIORead(linkID, dio)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tdio - DIO number\n");
        return;
    end

    if argn(2) == 1 then
        link_id = mdaqOpen();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    result = [];
    [state result] = call("sci_mlink_dio_get",..
            link_id, 1, "i",..
            dio, 2, "i",..
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
