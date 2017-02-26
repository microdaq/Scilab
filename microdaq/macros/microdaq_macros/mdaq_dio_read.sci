function state = mdaq_dio_read(arg1, arg2)
    state = -1;
    if argn(2) == 1 then
        dio = arg1; 
    end
    
    if argn(2) == 2 then
        link_id = arg1;   
        dio = arg2; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    if argn(2) > 2 | argn(2) < 1 then
        mprintf("Description:\n");
        mprintf("\tReads DIO state\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_dio_read(link_id, dio);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tdio - DIO number\n");
        return;
    end

    dio_count = mdaq_get_dio_config(); 
    if dio > dio_count | dio < 1 then
        disp("ERROR: Wrong DIO number!")
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

    if result < 0  then
        mdaq_error(result)
    end
    
    if argn(2) == 1 then
        mdaq_close(link_id);
    end
endfunction
