function mdaq_dio_dir(arg1, arg2, arg3)

    global %microdaq;
    if %microdaq.private.mdaq_hwid(1) <> 1100 then
        disp("ERROR: This function is not supported.")
        return;
    end
    
    if argn(2) == 2 then
        bank = arg1; 
        direction = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1;   
        bank = arg2; 
        direction = arg3; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tSets MicroDAQ DIO bank direction\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_dio_dir(link_id, bank, direction);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tbank - bank number (1-4)\n");
        mprintf("\tdirection - bank direction (1 - input, 0 - output)\n");
        return;
    end

    if bank < 1 | bank > 4 then
        disp("ERROR: Wrong bank number!")
        return;
    end

    if direction <> 0 then
        direction = 1;
    end

    if argn(2) == 2 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end

    result = call("sci_mlink_dio_set_dir",..
            link_id, 1, "i",..
            bank, 2, "i",..
            direction, 3, "i",..
            0, 4, "i",..
        "out",..
            [1, 1], 5, "i");

    if result < 0 then
        mdaq_error(result);
    end

    if argn(2) == 2 then
        mdaq_close(link_id);
    end

endfunction
