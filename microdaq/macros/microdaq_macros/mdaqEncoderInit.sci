function mdaqEncoderInit(arg1, arg2, arg3, arg4)
    if argn(2) == 3 then
        enc = arg1; 
        enc_mode = arg2;
        init_value = arg3; 
    end
    
    if argn(2) == 4 then
        link_id = arg1;   
        enc = arg2; 
        enc_mode = arg3;
        init_value = arg4; 

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    if argn(2) > 4 | argn(2) < 3 | enc > 2 | enc < 1 then
        mprintf("Description:\n");
        mprintf("\tInitializes encoder module\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqEncoderInit(linkID, module, mode, initValue)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tmodule - encoder module (1 | 2)\n");
        mprintf("\tmode - encoder mode (""quadrature"" | ""dir-count"" | ""up-count"" | ""down-count"")\n");
        mprintf("\tinitValue - initial position value\n");
        return;
    end

    if  type(enc_mode) == 10 then
        count_mode = convstr(enc_mode, 'l');
        select count_mode
        case "quadrature" then
          mode_arg = 0; 
        case "dir-count" then
          mode_arg = 1; 
        case "up-count" then
          mode_arg = 2; 
        case "down-count" then
          mode_arg = 3; 
        else
          error("Unsupported Encoder mode");
        end
    else
        if enc_mode < 0 | enc_mode > 4 then
            error("Unsupported Encoder mode");
        else 
            mode_arg = enc_mode; 
        end
    end
    
    if argn(2) == 3 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end
    
    result = call("sci_mlink_enc_reset",..
                link_id, 1, "i",..
                enc, 2, "i",..
                mode_arg, 3, "i",..
                init_value, 4, "i",..
            "out",..
                [1, 1], 5, "i");
                
    if argn(2) == 3 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
