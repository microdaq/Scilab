function mdaq_dio_func(arg1, arg2, arg3)
    
    if argn(2) == 2 then
        func = arg1; 
        enable = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1;   
        func = arg2; 
        enable = arg3; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    if argn(2) > 3 | argn(2) < 2 | func > 6 | func == 0 then
        mprintf("Description:\n");
        mprintf("\tSets DIO alternative function\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_dio_func(link_id, func, state);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tfunc - DIO alternative function\n");
        mprintf("\t\t1 - ENC1: DIO1 - Channel A, DIO2 - Channel B (enabled by default)\n");
        mprintf("\t\t2 - ENC2: DIO3 - Channel A, DIO4 - Channel B (enabled by default)\n");
        mprintf("\t\t3 - PWM1: DIO10 - Channel A, DIO11 - Channel B (enabled by default)\n");
        mprintf("\t\t4 - PWM2: DIO12 - Channel A, DIO13 - Channel B (enabled by default)\n");
        mprintf("\t\t5 - PWM3: DIO14 - Channel A, DIO14 - Channel B (enabled by default)\n");
        mprintf("\t\t6 - UART: DIO8 - Rx, DIO9 - Tx (enabled by default)\n");
        mprintf("\tstate - function state (%%T/%%F to enable/disable function)\n");
        return;
    end

    if enable <> %F then
        enable = 1;
    else
        enable = 0; 
    end
    
    if argn(2) == 2 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    result = call("sci_mlink_dio_set_func",..
            link_id, 1, "i",..
            func, 2, "i",..
            enable, 3, "i",..
        "out",..
            [1, 1], 4, "i");

    if result < 0 then
        mdaq_error(result);
    end

    if argn(2) == 2 then
        mdaq_close(link_id);
    end
endfunction
