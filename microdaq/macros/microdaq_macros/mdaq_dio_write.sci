function mdaq_dio_write(arg1, arg2, arg3)
    
    if argn(2) == 2 then
        dio = arg1; 
        state = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1;   
        dio = arg2; 
        state = arg3; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tWrites DIO state\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_dio_write(link_id, dio, state);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tdio - DIO number\n");
        mprintf("\tstate - DIO output state\n");
        return;
    end
    
    dio_count = mdaq_get_dio_config(); 
    if dio > dio_count | dio < 1 then
        disp("ERROR: Wrong DIO number!")
        return;
    end

    if type(state) == 4 then
        if state then
            state = 1;
        else 
            state = 0; 
        end
    else
        if state <> 0 then
           state = 1;  
        end
    end
    
    if argn(2) == 2 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end

    result = call("sci_mlink_dio_set",..
            link_id, 1, "i",..
            dio, 2, "i",..
            state, 3, "i",..
        "out",..
            [1, 1], 4, "i");

    if  result < 0  then
        mdaq_error(result); 
    end

    if argn(2) == 2 then
        mdaq_close(link_id);
    end

endfunction
