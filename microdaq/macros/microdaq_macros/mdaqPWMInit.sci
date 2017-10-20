function mdaqPWMInit(arg1, arg2, arg3, arg4)

    link_id = -1; 

    if argn(2) == 3 then
        module = arg1;  
        period = arg2; 
        active_low = arg3; 
    end
    
    if argn(2) == 4 then
        link_id = arg1; 
        module = arg2;  
        period = arg3; 
        active_low = arg4; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 4 | argn(2) < 3 | module > 3 | module < 1 | period > 500000 | period < 2 then
        mprintf("Description:\n");
        mprintf("\tSetup MicroDAQ PWM outputs\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqPWMInit(link_id, module, period, active_low);\n")
        mprintf("\tlink_id - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tmodule - PWM module (1, 2 or 3)\n");
        mprintf("\tperiod - PWM module period in microseconds(2-500000)\n");
        mprintf("\tactive_low - PWM waveform polarity (%%F or %%T)\n");
        return;
    end
    
    if type(active_low) == 4 then
        if active_low == %T then
            active_low = 1; 
        else 
            active_low = 0; 
        end
    else 
        if active_low <> 0 then
            active_low = 1;
        end  
    end
    
    
    if argn(2) == 3 then
        link_id = mdaqOpen();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    tmp = 0.0;
    result = [];
    result = call("sci_mlink_pwm_config",..
                link_id, 1, "i",..
                module, 2, "i",..
                period, 3, "i",..
                active_low, 4, "i",..
                tmp, 5, "d",..
                tmp, 6, "d",..
            "out",..
                [1, 1], 7, "i");

    if argn(2) == 3 then
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end 
endfunction