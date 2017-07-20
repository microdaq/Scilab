function mdaq_enc_init(arg1, arg2, arg3)
    if argn(2) == 2 then
        enc = arg1; 
        init_value = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1;   
        enc = arg2; 
        init_value = arg3; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 | enc > 2 | enc < 1 then
        mprintf("Description:\n");
        mprintf("\tInitializes encoder module\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_enc_init(link_id, encoder, init_value);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tencoder - encoder module (1 or 2)\n");
        mprintf("\tinit_value - initial encoder value\n");
        return;
    end

    if argn(2) == 2 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    result = call("sci_mlink_enc_reset",..
                link_id, 1, "i",..
                enc, 2, "i",..
                init_value, 3, "i",..
            "out",..
                [1, 1], 4, "i");
                
    if argn(2) == 2 then
        mdaq_close(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
